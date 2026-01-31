import 'package:flutter/material.dart';
import 'package:to_do_app/util/my_button.dart';
import 'package:to_do_app/util/color_utils.dart';
import 'package:to_do_app/util/priority_utils.dart';
import 'package:to_do_app/util/tag_utils.dart';
import 'package:to_do_app/util/category_utils.dart';

class DialogBox extends StatefulWidget {
  final TextEditingController controller;
  final Function(String, DateTime?, TimeOfDay?, String?, String, List<String>, String?) onSave;
  final VoidCallback onCancel;
  final DateTime? initialDate;
  final TimeOfDay? initialTime;
  final String? initialRecurrence;
  final String initialPriority;
  final List<String>? initialTags;
  final String? initialCategory;

  const DialogBox({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
    this.initialDate,
    this.initialTime,
    this.initialRecurrence,
    this.initialPriority = "medium",
    this.initialTags,
    this.initialCategory,
  });

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  String selectedColor = "yellow";
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedRecurrence;
  String selectedPriority = "medium";
  List<String> selectedTags = [];
  String? selectedCategory;
  final TextEditingController _customTagController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    selectedTime = widget.initialTime;
    selectedRecurrence = widget.initialRecurrence;
    selectedPriority = widget.initialPriority;
    selectedTags = widget.initialTags != null ? List<String>.from(widget.initialTags!) : [];
    selectedCategory = widget.initialCategory;
  }

  @override
  void dispose() {
    _customTagController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }


  Widget _buildColorOption(String colorName, Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = colorName;
        });
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selectedColor == colorName ? Colors.black : Colors.grey,
            width: selectedColor == colorName ? 3 : 1,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blue.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text(
        "Add New Task",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: "Enter task name",
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.task_alt),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Choose Color:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: availableColors
                  .map((colorData) => _buildColorOption(
                        colorData['name'] as String,
                        colorData['color'] as Color,
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              "Due Date & Time:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _selectDate(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Icon(Icons.calendar_today, size: 18),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            selectedDate != null
                                ? '${selectedDate!.month}/${selectedDate!.day}/${selectedDate!.year}'
                                : 'Select Date',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (selectedDate != null) ...[
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () {
                        setState(() {
                          selectedDate = null;
                          selectedTime = null;
                        });
                      },
                      tooltip: 'Clear date',
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              "Priority:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: availablePriorities.map((priorityData) {
                final priorityName = priorityData['name'] as String;
                final priorityLabel = priorityData['label'] as String;
                final priorityIcon = priorityData['icon'] as IconData;
                final priorityColor = priorityData['color'] as Color;
                
                return ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(priorityIcon, size: 16, color: priorityColor),
                      const SizedBox(width: 4),
                      Text(priorityLabel),
                    ],
                  ),
                  selected: selectedPriority == priorityName,
                  onSelected: (selected) {
                    setState(() {
                      selectedPriority = priorityName;
                    });
                  },
                  selectedColor: priorityColor.withOpacity(0.3),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              "Recurrence:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('None'),
                  selected: selectedRecurrence == null,
                  onSelected: (selected) {
                    setState(() {
                      selectedRecurrence = null;
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('Daily'),
                  selected: selectedRecurrence == 'daily',
                  onSelected: (selected) {
                    setState(() {
                      selectedRecurrence = 'daily';
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('Weekly'),
                  selected: selectedRecurrence == 'weekly',
                  onSelected: (selected) {
                    setState(() {
                      selectedRecurrence = 'weekly';
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('Monthly'),
                  selected: selectedRecurrence == 'monthly',
                  onSelected: (selected) {
                    setState(() {
                      selectedRecurrence = 'monthly';
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              "Tags:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            if (selectedTags.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: selectedTags.map((tag) {
                  return Chip(
                    label: Text(tag),
                    backgroundColor: getTagColor(tag),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () {
                      setState(() {
                        selectedTags.remove(tag);
                      });
                    },
                  );
                }).toList(),
              ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                ...commonTags.where((tag) => !selectedTags.contains(tag)).map((tag) {
                  return ActionChip(
                    label: Text(tag),
                    backgroundColor: getTagColor(tag),
                    onPressed: () {
                      setState(() {
                        if (!selectedTags.contains(tag)) {
                          selectedTags.add(tag);
                        }
                      });
                    },
                  );
                }).toList(),
                ActionChip(
                  label: const Text('+ Custom'),
                  icon: const Icon(Icons.add, size: 16),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Add Custom Tag'),
                        content: TextField(
                          controller: _customTagController,
                          decoration: const InputDecoration(
                            hintText: 'Enter tag name',
                          ),
                          autofocus: true,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              final customTag = _customTagController.text.trim();
                              if (customTag.isNotEmpty && !selectedTags.contains(customTag)) {
                                setState(() {
                                  selectedTags.add(customTag);
                                });
                              }
                              _customTagController.clear();
                              Navigator.pop(context);
                            },
                            child: const Text('Add'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              "Category:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                ChoiceChip(
                  label: const Text('None'),
                  selected: selectedCategory == null,
                  onSelected: (selected) {
                    setState(() {
                      selectedCategory = null;
                    });
                  },
                ),
                ...predefinedCategories.map((categoryData) {
                  final categoryName = categoryData['name'] as String;
                  final categoryIcon = categoryData['icon'] as IconData;
                  return ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(categoryIcon, size: 16),
                        const SizedBox(width: 4),
                        Text(categoryName),
                      ],
                    ),
                    selected: selectedCategory == categoryName,
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = selected ? categoryName : null;
                      });
                    },
                  );
                }).toList(),
              ],
            ),
          ],
        ),
      ),
      actions: [
        MyButton(
          text: "Save",
          onPressed: () => widget.onSave(selectedColor, selectedDate, selectedTime, selectedRecurrence, selectedPriority, selectedTags, selectedCategory),
        ),
        MyButton(text: "Cancel", onPressed: widget.onCancel),
      ],
    );
  }
}
