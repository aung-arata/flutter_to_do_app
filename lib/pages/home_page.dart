import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/data/auth_service.dart';
import 'package:to_do_app/data/database.dart';
import 'package:to_do_app/pages/login_page.dart';
import 'package:to_do_app/pages/settings_page.dart';
import 'package:to_do_app/util/dialog_box.dart';
import 'package:to_do_app/util/todo_tile.dart';
import 'package:to_do_app/util/group_tile.dart';
import 'package:to_do_app/util/group_dialog.dart';
import 'package:to_do_app/util/date_utils.dart' as date_utils;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box('mybox');
  ToDoDatabase db = ToDoDatabase();
  final _authService = AuthService();
  int? selectedGroupIndex;
  
  // Filter and sort state
  String _filterStatus = 'all'; // 'all', 'completed', 'incomplete'
  String _sortBy = 'none'; // 'none', 'name', 'completed', 'createdDate', 'dueDate'

  @override
  void initState() {
    super.initState();
    if (_myBox.get("TODOLIST") == null && _myBox.get("GROUPS") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    db.updateDatabase();
  }

  final _controller = TextEditingController();
  final _groupController = TextEditingController();

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      final task = db.toDoList[index];
      final wasCompleted = task['completed'] ?? false;
      task['completed'] = !wasCompleted;
      
      // Handle recurring tasks - only when task is being marked as completed
      if (wasCompleted == false && task['completed'] == true && task['recurrence'] != null) {
        // Task was just completed and has recurrence - create a new instance
        final recurrence = task['recurrence'];
        DateTime? currentDate = date_utils.parseDateTimeSafe(task['dueDate']);
        
        if (currentDate != null) {
          DateTime newDate;
          switch (recurrence) {
            case 'daily':
              newDate = currentDate.add(const Duration(days: 1));
              break;
            case 'weekly':
              newDate = currentDate.add(const Duration(days: 7));
              break;
            case 'monthly':
              // Add one month with proper handling of month-end dates
              // If the day doesn't exist in the target month, use the last day of that month
              int targetMonth = currentDate.month + 1;
              int targetYear = currentDate.year;
              if (targetMonth > 12) {
                targetMonth = 1;
                targetYear++;
              }
              // Get the last day of the target month
              int lastDayOfTargetMonth = DateTime(targetYear, targetMonth + 1, 0).day;
              int targetDay = currentDate.day > lastDayOfTargetMonth ? lastDayOfTargetMonth : currentDate.day;
              newDate = DateTime(targetYear, targetMonth, targetDay);
              break;
            default:
              newDate = currentDate;
          }
          
          // Create new task with updated date
          db.toDoList.add({
            'name': task['name'],
            'completed': false,
            'color': task['color'],
            'groupIndex': task['groupIndex'],
            'subNotes': [], // Don't copy sub-notes to recurring task
            'dueDate': newDate.toIso8601String(),
            'dueTime': task['dueTime'],
            'recurrence': recurrence,
            'createdAt': DateTime.now().toIso8601String(),
          });
        }
      }
    });
    db.updateDatabase();
  }

  void saveNewTask(String color, DateTime? dueDate, TimeOfDay? dueTime, String? recurrence) {
    if (_controller.text.trim().isEmpty) {
      return;
    }
    setState(() {
      db.toDoList.add({
        'name': _controller.text,
        'completed': false,
        'color': color,
        'groupIndex': selectedGroupIndex ?? (db.groups.isNotEmpty ? 0 : -1),
        'subNotes': [],
        'dueDate': dueDate?.toIso8601String(),
        'dueTime': dueTime != null ? _formatTimeOfDay(dueTime) : null,
        'recurrence': recurrence,
        'createdAt': DateTime.now().toIso8601String(),
      });
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDatabase();
  }

  void createNewTask() {
    // Show group selection dialog if there are groups
    if (db.groups.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text('Select Group'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...db.groups.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final group = entry.value;
                  return ListTile(
                    title: Text(group['name']),
                    leading: Radio<int>(
                      value: idx,
                      groupValue: selectedGroupIndex,
                      onChanged: (value) {
                        setState(() {
                          selectedGroupIndex = value;
                        });
                        Navigator.of(context).pop();
                        _showTaskDialog();
                      },
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        },
      );
    } else {
      _showTaskDialog();
    }
  }

  void _showTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void deleteTask(int index) {
    // Store task and trash index for undo
    final deletedTask = Map<String, dynamic>.from(db.toDoList[index]);
    final originalIndex = index;
    
    setState(() {
      // Move task to trash instead of deleting
      var task = db.toDoList[index];
      task['deletedAt'] = DateTime.now().toIso8601String();
      final trashIndex = db.trash.length;
      db.trash.add(task);
      db.toDoList.removeAt(index);
      
      // Store trash index for undo
      deletedTask['_undoTrashIndex'] = trashIndex;
    });
    db.updateDatabase();
    
    // Show snackbar with undo option
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Task moved to trash'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              // Find and remove from trash using the stored index
              final trashIndex = deletedTask['_undoTrashIndex'] as int;
              if (trashIndex < db.trash.length) {
                var restoredTask = Map<String, dynamic>.from(db.trash[trashIndex]);
                restoredTask.remove('deletedAt');
                restoredTask.remove('_undoTrashIndex');
                db.trash.removeAt(trashIndex);
                db.toDoList.insert(originalIndex, restoredTask);
              }
            });
            db.updateDatabase();
          },
        ),
      ),
    );
  }

  void changeTaskColor(int index, String newColor) {
    setState(() {
      db.toDoList[index]['color'] = newColor;
    });
    db.updateDatabase();
  }

  void addSubNote(int taskIndex, String subNoteName) {
    setState(() {
      if (db.toDoList[taskIndex]['subNotes'] == null) {
        db.toDoList[taskIndex]['subNotes'] = [];
      }
      db.toDoList[taskIndex]['subNotes'].add({
        'name': subNoteName,
        'completed': false,
        'color': 'yellow',  // Default color for new sub-notes
      });
    });
    db.updateDatabase();
  }

  void toggleSubNote(int taskIndex, int subNoteIndex, bool completed) {
    setState(() {
      db.toDoList[taskIndex]['subNotes'][subNoteIndex]['completed'] = completed;
    });
    db.updateDatabase();
  }

  void deleteSubNote(int taskIndex, int subNoteIndex) {
    setState(() {
      db.toDoList[taskIndex]['subNotes'].removeAt(subNoteIndex);
    });
    db.updateDatabase();
  }

  void changeSubNoteColor(int taskIndex, int subNoteIndex, String newColor) {
    setState(() {
      if (db.toDoList[taskIndex]['subNotes'][subNoteIndex] is Map) {
        db.toDoList[taskIndex]['subNotes'][subNoteIndex]['color'] = newColor;
      }
    });
    db.updateDatabase();
  }

  TimeOfDay? _parseTimeOfDay(String? timeString) {
    if (timeString == null) return null;
    try {
      final parts = timeString.split(':');
      if (parts.length != 2) return null;
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return null;
    }
  }

  String _formatTimeOfDay(TimeOfDay time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }



  void editTaskDateTime(int taskIndex) {
    final task = db.toDoList[taskIndex];
    DateTime? currentDate = date_utils.parseDateTimeSafe(task['dueDate']);
    TimeOfDay? currentTime = _parseTimeOfDay(task['dueTime']);
    String? currentRecurrence = task['recurrence'];
    
    showDialog(
      context: context,
      builder: (context) {
        DateTime? selectedDate = currentDate;
        TimeOfDay? selectedTime = currentTime;
        String? selectedRecurrence = currentRecurrence;
        
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> selectDate() async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                setDialogState(() {
                  selectedDate = picked;
                });
              }
            }


            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text('Edit Due Date & Time'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: selectDate,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
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
                                setDialogState(() {
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
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Recurrence:',
                        style: TextStyle(fontWeight: FontWeight.bold),
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
                            setDialogState(() {
                              selectedRecurrence = null;
                            });
                          },
                        ),
                        ChoiceChip(
                          label: const Text('Daily'),
                          selected: selectedRecurrence == 'daily',
                          onSelected: (selected) {
                            setDialogState(() {
                              selectedRecurrence = 'daily';
                            });
                          },
                        ),
                        ChoiceChip(
                          label: const Text('Weekly'),
                          selected: selectedRecurrence == 'weekly',
                          onSelected: (selected) {
                            setDialogState(() {
                              selectedRecurrence = 'weekly';
                            });
                          },
                        ),
                        ChoiceChip(
                          label: const Text('Monthly'),
                          selected: selectedRecurrence == 'monthly',
                          onSelected: (selected) {
                            setDialogState(() {
                              selectedRecurrence = 'monthly';
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      db.toDoList[taskIndex]['dueDate'] = selectedDate?.toIso8601String();
                      db.toDoList[taskIndex]['dueTime'] = selectedTime != null 
                          ? _formatTimeOfDay(selectedTime!) 
                          : null;
                      db.toDoList[taskIndex]['recurrence'] = selectedRecurrence;
                    });
                    db.updateDatabase();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void moveTaskToGroup(int taskIndex, int targetGroupIndex) {
    setState(() {
      db.toDoList[taskIndex]['groupIndex'] = targetGroupIndex;
    });
    db.updateDatabase();
  }

  void moveSubNoteToTask(int sourceTaskIndex, int subNoteIndex, int targetTaskIndex) {
    setState(() {
      var subNote = db.toDoList[sourceTaskIndex]['subNotes'][subNoteIndex];
      db.toDoList[sourceTaskIndex]['subNotes'].removeAt(subNoteIndex);
      db.toDoList[targetTaskIndex]['subNotes'].add(subNote);
    });
    db.updateDatabase();
  }

  void reorderSubNotes(int taskIndex, int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final subNote = db.toDoList[taskIndex]['subNotes'].removeAt(oldIndex);
      db.toDoList[taskIndex]['subNotes'].insert(newIndex, subNote);
    });
    db.updateDatabase();
  }

  void toggleGroupExpansion(int groupIndex) {
    setState(() {
      db.groups[groupIndex]['expanded'] = !db.groups[groupIndex]['expanded'];
    });
    db.updateDatabase();
  }

  void reorderGroups(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final group = db.groups.removeAt(oldIndex);
      db.groups.insert(newIndex, group);
      
      // Update groupIndex for all tasks
      for (var task in db.toDoList) {
        final taskGroupIndex = task['groupIndex'];
        if (taskGroupIndex == oldIndex) {
          task['groupIndex'] = newIndex;
        } else if (oldIndex < newIndex) {
          // Moving down: adjust tasks in between
          if (taskGroupIndex > oldIndex && taskGroupIndex <= newIndex) {
            task['groupIndex']--;
          }
        } else {
          // Moving up: adjust tasks in between
          if (taskGroupIndex >= newIndex && taskGroupIndex < oldIndex) {
            task['groupIndex']++;
          }
        }
      }
    });
    db.updateDatabase();
  }

  void reorderTasksInGroup(int? groupIndex, int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      
      // Get tasks in this group
      final groupTasks = db.toDoList.asMap().entries.where((entry) {
        if (groupIndex != null) {
          return entry.value['groupIndex'] == groupIndex;
        }
        return true;
      }).toList();
      
      // Get the actual indices in the main list
      final taskIndex1 = groupTasks[oldIndex].key;
      final taskIndex2 = groupTasks[newIndex].key;
      
      // Swap the tasks
      final temp = db.toDoList[taskIndex1];
      db.toDoList[taskIndex1] = db.toDoList[taskIndex2];
      db.toDoList[taskIndex2] = temp;
    });
    db.updateDatabase();
  }

  void createNewGroup() {
    _groupController.clear();
    
    showDialog(
      context: context,
      builder: (context) {
        return GroupDialog(
          controller: _groupController,
          onSave: (icon, color) {
            if (_groupController.text.trim().isEmpty) {
              return;
            }
            setState(() {
              db.groups.add({
                'name': _groupController.text,
                'icon': icon,
                'color': color,
                'expanded': true,
              });
            });
            Navigator.of(context).pop();
            db.updateDatabase();
          },
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void editGroup(int index) {
    _groupController.text = db.groups[index]['name'];
    
    showDialog(
      context: context,
      builder: (context) {
        return GroupDialog(
          controller: _groupController,
          initialIcon: db.groups[index]['icon'],
          initialColor: db.groups[index]['color'],
          onSave: (icon, color) {
            if (_groupController.text.trim().isEmpty) {
              return;
            }
            setState(() {
              db.groups[index]['name'] = _groupController.text;
              db.groups[index]['icon'] = icon;
              db.groups[index]['color'] = color;
            });
            Navigator.of(context).pop();
            db.updateDatabase();
          },
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void deleteGroup(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Delete Group?'),
          content: Text('This will delete all tasks in "${db.groups[index]['name']}" group.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // Remove all tasks in this group
                  db.toDoList.removeWhere((task) => task['groupIndex'] == index);
                  // Update groupIndex for tasks after this group
                  for (var task in db.toDoList) {
                    if (task['groupIndex'] > index) {
                      task['groupIndex']--;
                    }
                  }
                  db.groups.removeAt(index);
                });
                Navigator.of(context).pop();
                db.updateDatabase();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void showMoveTaskDialog(int taskIndex) {
    if (db.groups.length <= 1) {
      // Need at least 2 groups to move
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Create more groups to move tasks between them'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Move Task to Group'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...db.groups.asMap().entries.map((entry) {
                final idx = entry.key;
                final group = entry.value;
                final currentGroupIndex = db.toDoList[taskIndex]['groupIndex'];
                
                if (idx == currentGroupIndex) {
                  return const SizedBox.shrink();
                }
                
                return ListTile(
                  title: Text(group['name']),
                  leading: const Icon(Icons.folder),
                  onTap: () {
                    moveTaskToGroup(taskIndex, idx);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Task moved to ${group['name']}'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  void showMoveSubNoteDialog(int sourceTaskIndex, int subNoteIndex) {
    final eligibleTasks = db.toDoList.asMap().entries.where(
      (entry) => entry.key != sourceTaskIndex,
    ).toList();

    if (eligibleTasks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Create more tasks to move sub-notes between them'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Move Sub-note to Task'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: eligibleTasks.map((entry) {
                final idx = entry.key;
                final task = entry.value;
                
                return ListTile(
                  title: Text(task['name']),
                  leading: const Icon(Icons.task),
                  onTap: () {
                    moveSubNoteToTask(sourceTaskIndex, subNoteIndex, idx);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Sub-note moved to ${task['name']}'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  List<MapEntry<int, dynamic>> _getFilteredAndSortedTasks(int? groupIndex) {
    // Get tasks for the specified group (or all if null)
    var tasks = db.toDoList.asMap().entries.where((entry) {
      if (groupIndex != null && entry.value['groupIndex'] != groupIndex) {
        return false;
      }
      return true;
    }).toList();

    // Apply status filter
    if (_filterStatus == 'completed') {
      tasks = tasks.where((entry) => entry.value['completed'] == true).toList();
    } else if (_filterStatus == 'incomplete') {
      tasks = tasks.where((entry) => entry.value['completed'] == false).toList();
    }

    // Apply sorting
    if (_sortBy == 'name') {
      tasks.sort((a, b) {
        String nameA = a.value['name'] ?? '';
        String nameB = b.value['name'] ?? '';
        return nameA.toLowerCase().compareTo(nameB.toLowerCase());
      });
    } else if (_sortBy == 'completed') {
      tasks.sort((a, b) {
        bool completedA = a.value['completed'] ?? false;
        bool completedB = b.value['completed'] ?? false;
        // Show incomplete tasks first
        return completedA == completedB ? 0 : (completedA ? 1 : -1);
      });
    } else if (_sortBy == 'createdDate') {
      tasks.sort((a, b) {
        DateTime? dateA = date_utils.parseDateTimeSafe(a.value['createdAt']);
        DateTime? dateB = date_utils.parseDateTimeSafe(b.value['createdAt']);
        if (dateA == null && dateB == null) return 0;
        if (dateA == null) return 1;
        if (dateB == null) return -1;
        // Most recent first
        return dateB.compareTo(dateA);
      });
    } else if (_sortBy == 'dueDate') {
      tasks.sort((a, b) {
        DateTime? dateA = date_utils.parseDateTimeSafe(a.value['dueDate']);
        DateTime? dateB = date_utils.parseDateTimeSafe(b.value['dueDate']);
        // Tasks with no due date go to the end
        if (dateA == null && dateB == null) return 0;
        if (dateA == null) return 1;
        if (dateB == null) return -1;
        // Earliest due date first
        return dateA.compareTo(dateB);
      });
    }

    return tasks;
  }

  void _showFilterSortDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            // Helper to update both dialog and parent state
            void updateBothStates(Function() updates) {
              setDialogState(updates);
              setState(updates);
            }
            
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text('Filter & Sort'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Status',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text('All'),
                          selected: _filterStatus == 'all',
                          onSelected: (selected) {
                            updateBothStates(() => _filterStatus = 'all');
                          },
                        ),
                        ChoiceChip(
                          label: const Text('Completed'),
                          selected: _filterStatus == 'completed',
                          onSelected: (selected) {
                            updateBothStates(() => _filterStatus = 'completed');
                          },
                        ),
                        ChoiceChip(
                          label: const Text('Incomplete'),
                          selected: _filterStatus == 'incomplete',
                          onSelected: (selected) {
                            updateBothStates(() => _filterStatus = 'incomplete');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Sort By',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text('None'),
                          selected: _sortBy == 'none',
                          onSelected: (selected) {
                            updateBothStates(() => _sortBy = 'none');
                          },
                        ),
                        ChoiceChip(
                          label: const Text('Name'),
                          selected: _sortBy == 'name',
                          onSelected: (selected) {
                            updateBothStates(() => _sortBy = 'name');
                          },
                        ),
                        ChoiceChip(
                          label: const Text('Status'),
                          selected: _sortBy == 'completed',
                          onSelected: (selected) {
                            updateBothStates(() => _sortBy = 'completed');
                          },
                        ),
                        ChoiceChip(
                          label: const Text('Created Date'),
                          selected: _sortBy == 'createdDate',
                          onSelected: (selected) {
                            updateBothStates(() => _sortBy = 'createdDate');
                          },
                        ),
                        ChoiceChip(
                          label: const Text('Due Date'),
                          selected: _sortBy == 'dueDate',
                          onSelected: (selected) {
                            updateBothStates(() => _sortBy = 'dueDate');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Reset filters
                    updateBothStates(() {
                      _filterStatus = 'all';
                      _sortBy = 'none';
                    });
                  },
                  child: const Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _logout() async {
    await _authService.logout();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _authService.getCurrentUser();
    
    // Build list of widgets based on groups
    List<Widget> buildTaskList() {
      List<Widget> widgets = [];
      
      if (db.groups.isEmpty) {
        // No groups - show all tasks with filtering and sorting
        final filteredTasks = _getFilteredAndSortedTasks(null);
        for (var entry in filteredTasks) {
          final i = entry.key;
          final task = entry.value;
          widgets.add(
            ReorderableDragStartListener(
              key: ValueKey('task_$i'),
              index: widgets.length,
              child: ToDoTile(
                taskName: task['name'] ?? '',
                taskCompleted: task['completed'] ?? false,
                taskColor: task['color'] ?? 'yellow',
                subNotes: task['subNotes'] ?? [],
                dueDate: date_utils.parseDateTimeSafe(task['dueDate']),
                dueTime: _parseTimeOfDay(task['dueTime']),
                recurrence: task['recurrence'],
                onChanged: (value) => checkBoxChanged(value, i),
                deleteFunction: (context) => deleteTask(i),
                onColorChanged: (color) => changeTaskColor(i, color),
                onAddSubNote: (subNote) => addSubNote(i, subNote),
                onSubNoteChanged: (subIdx, completed) => toggleSubNote(i, subIdx, completed),
                onDeleteSubNote: (subIdx) => deleteSubNote(i, subIdx),
                onSubNoteColorChanged: (subIdx, color) => changeSubNoteColor(i, subIdx, color),
                onMoveTask: null,  // No groups, can't move
                onMoveSubNote: (subIdx) => showMoveSubNoteDialog(i, subIdx),
                onReorderSubNotes: (oldIdx, newIdx) => reorderSubNotes(i, oldIdx, newIdx),
                onEditDateTime: () => editTaskDateTime(i),
              ),
            ),
          );
        }
      } else {
        // Show groups with tasks
        for (int groupIdx = 0; groupIdx < db.groups.length; groupIdx++) {
          final group = db.groups[groupIdx];
          final isExpanded = group['expanded'] ?? true;
          
          widgets.add(
            ReorderableDragStartListener(
              key: ValueKey('group_$groupIdx'),
              index: widgets.length,
              child: GroupTile(
                groupName: group['name'] ?? 'Group',
                icon: group['icon'] ?? 'person',
                color: group['color'] ?? 'blue',
                expanded: isExpanded,
                onTap: () => toggleGroupExpansion(groupIdx),
                onDelete: (context) => deleteGroup(groupIdx),
                onEdit: (context) => editGroup(groupIdx),
              ),
            ),
          );
          
          if (isExpanded) {
            // Show tasks in this group with filtering and sorting
            final filteredTasks = _getFilteredAndSortedTasks(groupIdx);
            for (var entry in filteredTasks) {
              final i = entry.key;
              final task = entry.value;
              widgets.add(
                ReorderableDragStartListener(
                  key: ValueKey('task_${groupIdx}_$i'),
                  index: widgets.length,
                  child: ToDoTile(
                    taskName: task['name'] ?? '',
                    taskCompleted: task['completed'] ?? false,
                    taskColor: task['color'] ?? 'yellow',
                    subNotes: task['subNotes'] ?? [],
                    dueDate: date_utils.parseDateTimeSafe(task['dueDate']),
                    dueTime: _parseTimeOfDay(task['dueTime']),
                    recurrence: task['recurrence'],
                    onChanged: (value) => checkBoxChanged(value, i),
                    deleteFunction: (context) => deleteTask(i),
                    onColorChanged: (color) => changeTaskColor(i, color),
                    onAddSubNote: (subNote) => addSubNote(i, subNote),
                    onSubNoteChanged: (subIdx, completed) => toggleSubNote(i, subIdx, completed),
                    onDeleteSubNote: (subIdx) => deleteSubNote(i, subIdx),
                    onSubNoteColorChanged: (subIdx, color) => changeSubNoteColor(i, subIdx, color),
                    onMoveTask: () => showMoveTaskDialog(i),
                    onMoveSubNote: (subIdx) => showMoveSubNoteDialog(i, subIdx),
                    onReorderSubNotes: (oldIdx, newIdx) => reorderSubNotes(i, oldIdx, newIdx),
                    onEditDateTime: () => editTaskDateTime(i),
                  ),
                ),
              );
            }
          }
        }
      }
      
      return widgets;
    }
    
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("My Tasks${currentUser != null ? ' - $currentUser' : ''}"),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade400, Colors.blue.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.filter_list),
                if (_filterStatus != 'all' || _sortBy != 'none')
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: _showFilterSortDialog,
            tooltip: 'Filter & Sort',
          ),
          if (db.groups.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.create_new_folder),
              onPressed: createNewGroup,
              tooltip: 'Add Group',
            ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
            tooltip: 'Settings',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (db.groups.isEmpty)
            FloatingActionButton(
              heroTag: 'addGroup',
              onPressed: createNewGroup,
              backgroundColor: Colors.orange,
              child: const Icon(Icons.create_new_folder),
            ),
          if (db.groups.isEmpty) const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'addTask',
            onPressed: createNewTask,
            backgroundColor: Colors.blue,
            child: const Icon(Icons.add),
          ),
        ],
      ),
      body: db.toDoList.isEmpty && db.groups.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.task_alt,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tasks yet!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create a group or add a task to get started',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : db.groups.isEmpty
              ? ReorderableListView(
                  padding: const EdgeInsets.only(bottom: 100, top: 20),
                  onReorder: (oldIndex, newIndex) {
                    // Reorder tasks when no groups exist
                    setState(() {
                      if (newIndex > oldIndex) {
                        newIndex -= 1;
                      }
                      final task = db.toDoList.removeAt(oldIndex);
                      db.toDoList.insert(newIndex, task);
                      db.updateDatabase();
                    });
                  },
                  children: buildTaskList(),
                )
              : ListView(
                  padding: const EdgeInsets.only(bottom: 100, top: 20),
                  children: buildTaskList().map((widget) {
                    // Remove ReorderableDragStartListener wrapper when groups exist
                    if (widget is ReorderableDragStartListener) {
                      return widget.child;
                    }
                    return widget;
                  }).toList(),
                ),
    );
  }
}
