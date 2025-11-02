import 'package:flutter/material.dart';
import 'package:to_do_app/util/my_button.dart';
import 'package:to_do_app/util/color_utils.dart';

class DialogBox extends StatefulWidget {
  final TextEditingController controller;
  final Function(String, DateTime?, TimeOfDay?, String?) onSave;
  final VoidCallback onCancel;
  final DateTime? initialDate;
  final TimeOfDay? initialTime;
  final String? initialRecurrence;

  const DialogBox({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
    this.initialDate,
    this.initialTime,
    this.initialRecurrence,
  });

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  String selectedColor = "yellow";
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedRecurrence;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    selectedTime = widget.initialTime;
    selectedRecurrence = widget.initialRecurrence;
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

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
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
                  child: OutlinedButton.icon(
                    onPressed: () => _selectDate(context),
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      selectedDate != null
                          ? '${selectedDate!.month}/${selectedDate!.day}/${selectedDate!.year}'
                          : 'Select Date',
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                if (selectedDate != null) ...[
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: IconButton(
                      icon: const Icon(Icons.close),
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
            const SizedBox(height: 8),
            if (selectedDate != null)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _selectTime(context),
                      icon: const Icon(Icons.access_time),
                      label: Text(
                        selectedTime != null
                            ? selectedTime!.format(context)
                            : 'Select Time (optional)',
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  if (selectedTime != null) ...[
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            selectedTime = null;
                          });
                        },
                        tooltip: 'Clear time',
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ],
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
          ],
        ),
      ),
      actions: [
        MyButton(
          text: "Save",
          onPressed: () => widget.onSave(selectedColor, selectedDate, selectedTime, selectedRecurrence),
        ),
        MyButton(text: "Cancel", onPressed: widget.onCancel),
      ],
    );
  }
}
