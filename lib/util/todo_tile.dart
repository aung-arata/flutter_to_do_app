import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_app/util/color_utils.dart';

class ToDoTile extends StatefulWidget {
  final String taskName;
  final bool taskCompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? deleteFunction;
  final Function(String)? onColorChanged;
  final String taskColor;
  final List<dynamic>? subNotes;
  final Function(String)? onAddSubNote;
  final Function(int, bool)? onSubNoteChanged;
  final Function(int)? onDeleteSubNote;
  final Function(int, String)? onSubNoteColorChanged;
  final Function()? onMoveTask;
  final Function(int)? onMoveSubNote;
  final Function(int, int)? onReorderSubNotes;
  final DateTime? dueDate;
  final TimeOfDay? dueTime;
  final Function()? onEditDateTime;
  final String? recurrence;

  const ToDoTile({
    super.key,
    required this.taskName,
    required this.taskCompleted,
    required this.onChanged,
    required this.deleteFunction,
    this.onColorChanged,
    this.taskColor = "yellow",
    this.subNotes,
    this.onAddSubNote,
    this.onSubNoteChanged,
    this.onDeleteSubNote,
    this.onSubNoteColorChanged,
    this.onMoveTask,
    this.onMoveSubNote,
    this.onReorderSubNotes,
    this.dueDate,
    this.dueTime,
    this.onEditDateTime,
    this.recurrence,
  });

  @override
  State<ToDoTile> createState() => _ToDoTileState();
}

class _ToDoTileState extends State<ToDoTile> {
  // Delay to ensure options dialog is fully closed before opening color picker dialog
  // 100ms is sufficient for the dialog close animation to complete
  static const Duration _dialogTransitionDelay = Duration(milliseconds: 100);
  
  bool _showSubNotes = false;

  void _showAddSubNoteDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Add Sub-note'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter sub-note',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty && widget.onAddSubNote != null) {
                  widget.onAddSubNote!(controller.text.trim());
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDateTimeDisplay() {
    if (widget.dueDate == null && widget.recurrence == null) {
      return const SizedBox.shrink();
    }
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    DateTime? taskDate;
    bool isOverdue = false;
    bool isToday = false;
    
    if (widget.dueDate != null) {
      taskDate = DateTime(widget.dueDate!.year, widget.dueDate!.month, widget.dueDate!.day);
      isOverdue = taskDate.isBefore(today) && !widget.taskCompleted;
      isToday = taskDate.isAtSameMomentAs(today);
    }
    
    String dateText = '';
    if (widget.dueDate != null) {
      if (isToday) {
        dateText = 'Today';
      } else {
        dateText = '${widget.dueDate!.month}/${widget.dueDate!.day}/${widget.dueDate!.year}';
      }
      
      if (widget.dueTime != null) {
        final period = widget.dueTime!.period == DayPeriod.am ? 'AM' : 'PM';
        final hour = widget.dueTime!.hourOfPeriod == 0 ? 12 : widget.dueTime!.hourOfPeriod;
        final minute = widget.dueTime!.minute.toString().padLeft(2, '0');
        dateText += ', $hour:$minute $period';
      }
    }
    
    // Add recurrence info
    if (widget.recurrence != null) {
      String recurrenceText = '';
      switch (widget.recurrence) {
        case 'daily':
          recurrenceText = '🔁 Daily';
          break;
        case 'weekly':
          recurrenceText = '🔁 Weekly';
          break;
        case 'monthly':
          recurrenceText = '🔁 Monthly';
          break;
      }
      if (dateText.isNotEmpty) {
        dateText += ' - $recurrenceText';
      } else {
        dateText = recurrenceText;
      }
    }
    
    return GestureDetector(
      onTap: widget.onEditDateTime,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isOverdue ? Colors.red.shade100 : Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isOverdue ? Colors.red.shade700 : Colors.black45,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.recurrence != null ? Icons.repeat : Icons.calendar_today,
              size: 14,
              color: isOverdue ? Colors.red.shade900 : Colors.black87,
            ),
            const SizedBox(width: 4),
            Text(
              dateText,
              style: TextStyle(
                fontSize: 13,
                color: isOverdue ? Colors.red.shade900 : Colors.black87,
                fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTaskOptionsMenu(BuildContext context) {
    // Show a popup menu with task options
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Task Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.onEditDateTime != null)
                ListTile(
                  leading: Icon(Icons.calendar_month, color: Colors.purple.shade600),
                  title: const Text('Edit Date & Time'),
                  onTap: () {
                    Navigator.of(dialogContext).pop();
                    widget.onEditDateTime!();
                  },
                ),
              ListTile(
                leading: Icon(Icons.color_lens, color: Colors.blue.shade600),
                title: const Text('Change Color'),
                onTap: () {
                  Navigator.of(dialogContext).pop();
                  // Add a small delay to ensure the previous dialog is fully closed
                  Future.delayed(_dialogTransitionDelay, () {
                    _showColorPicker(context);
                  });
                },
              ),
              if (widget.onMoveTask != null)
                ListTile(
                  leading: Icon(Icons.drive_file_move, color: Colors.orange.shade600),
                  title: const Text('Move to Group'),
                  onTap: () {
                    Navigator.of(dialogContext).pop();
                    widget.onMoveTask!();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _showColorPicker(BuildContext context) {
    // Helper function to build a color option
    Widget buildColorOption(BuildContext dialogContext, String colorName, Color color) {
      return GestureDetector(
        onTap: () {
          if (widget.onColorChanged != null) {
            widget.onColorChanged!(colorName);
          }
          Navigator.of(dialogContext).pop();
        },
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: widget.taskColor == colorName ? Colors.black : Colors.grey,
              width: widget.taskColor == colorName ? 3 : 1,
            ),
          ),
        ),
      );
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Choose Color'),
          content: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: availableColors
                .map((colorData) => buildColorOption(
                      dialogContext,
                      colorData['name'] as String,
                      colorData['color'] as Color,
                    ))
                .toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasSubNotes = widget.subNotes != null && widget.subNotes!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(left: 25.0, top: 12, right: 25),
      child: Column(
        children: [
          Slidable(
            endActionPane: ActionPane(
              motion: const StretchMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) => _showTaskOptionsMenu(context),
                  icon: Icons.more_vert,
                  backgroundColor: Colors.blue.shade400,
                  borderRadius: BorderRadius.circular(12),
                  label: 'Options',
                ),
                SlidableAction(
                  onPressed: widget.deleteFunction,
                  icon: Icons.delete,
                  backgroundColor: Colors.red.shade300,
                  borderRadius: BorderRadius.circular(12),
                  label: 'Delete',
                )
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    getColorFromString(widget.taskColor),
                    getColorFromString(widget.taskColor).withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Checkbox(
                            value: widget.taskCompleted,
                            onChanged: widget.onChanged,
                            activeColor: Colors.green.shade700,
                            checkColor: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.taskName,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  decoration: widget.taskCompleted
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  color: Colors.black87,
                                ),
                              ),
                              if (widget.dueDate != null) ...[
                                const SizedBox(height: 4),
                                _buildDateTimeDisplay(),
                              ],
                            ],
                          ),
                        ),
                        if (hasSubNotes)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${widget.subNotes!.length}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: _showAddSubNoteDialog,
                          tooltip: 'Add sub-note',
                          iconSize: 24,
                          color: Colors.black87,
                        ),
                        if (hasSubNotes)
                          IconButton(
                            icon: Icon(
                              _showSubNotes ? Icons.expand_less : Icons.expand_more,
                            ),
                            onPressed: () {
                              setState(() {
                                _showSubNotes = !_showSubNotes;
                              });
                            },
                            tooltip: _showSubNotes ? 'Hide sub-notes' : 'Show sub-notes',
                            iconSize: 24,
                            color: Colors.black87,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (hasSubNotes && _showSubNotes)
            ...widget.subNotes!.asMap().entries.map((entry) {
              final index = entry.key;
              final subNote = entry.value;
              final name = subNote['name'] ?? '';
              final completed = subNote['completed'] ?? false;
              final subNoteColor = subNote['color'] ?? 'yellow';
              
              return Padding(
                key: ValueKey('subnote_$index'),
                padding: const EdgeInsets.only(left: 40, top: 8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        getColorFromString(subNoteColor).withOpacity(0.5),
                        getColorFromString(subNoteColor).withOpacity(0.3),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: getColorFromString(subNoteColor).withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      if (widget.onReorderSubNotes != null) ...[
                        Icon(Icons.drag_handle, color: Colors.grey[600], size: 18),
                        const SizedBox(width: 8),
                      ],
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Checkbox(
                          value: completed,
                          onChanged: (value) {
                            if (widget.onSubNoteChanged != null) {
                              widget.onSubNoteChanged!(index, value ?? false);
                            }
                          },
                          activeColor: Colors.green.shade600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: 14,
                            decoration: completed
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      if (widget.onSubNoteColorChanged != null)
                        IconButton(
                          icon: const Icon(Icons.palette, size: 18),
                          onPressed: () {
                            // Show color picker for sub-note
                            showDialog(
                              context: context,
                              builder: (BuildContext dialogContext) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  title: const Text('Choose Sub-note Color'),
                                  content: Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: availableColors
                                        .map((colorData) => GestureDetector(
                                              onTap: () {
                                                widget.onSubNoteColorChanged!(
                                                  index,
                                                  colorData['name'] as String,
                                                );
                                                Navigator.of(dialogContext).pop();
                                              },
                                              child: Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  color: colorData['color'] as Color,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: subNoteColor == colorData['name']
                                                        ? Colors.black
                                                        : Colors.grey,
                                                    width: subNoteColor == colorData['name'] ? 3 : 1,
                                                  ),
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                );
                              },
                            );
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          color: Colors.blue.shade600,
                        ),
                      if (widget.onMoveSubNote != null)
                        IconButton(
                          icon: const Icon(Icons.drive_file_move, size: 18),
                          onPressed: () => widget.onMoveSubNote!(index),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          color: Colors.orange.shade600,
                        ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () {
                          if (widget.onDeleteSubNote != null) {
                            widget.onDeleteSubNote!(index);
                          }
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        color: Colors.red.shade400,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
        ],
      ),
    );
  }
}
