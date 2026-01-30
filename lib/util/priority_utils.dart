import 'package:flutter/material.dart';

// Available priority levels for tasks
const List<Map<String, dynamic>> availablePriorities = [
  {
    'name': 'high',
    'label': 'High',
    'icon': Icons.priority_high,
    'color': Colors.red,
  },
  {
    'name': 'medium',
    'label': 'Medium',
    'icon': Icons.remove,
    'color': Colors.orange,
  },
  {
    'name': 'low',
    'label': 'Low',
    'icon': Icons.arrow_downward,
    'color': Colors.green,
  },
];

// Get priority details from priority name
Map<String, dynamic>? getPriorityDetails(String priorityName) {
  return availablePriorities.firstWhere(
    (p) => p['name'] == priorityName.toLowerCase(),
    orElse: () => availablePriorities[1], // Default to medium
  );
}

// Get priority color from priority name
Color getPriorityColor(String priorityName) {
  final details = getPriorityDetails(priorityName);
  return details?['color'] ?? Colors.orange;
}

// Get priority icon from priority name
IconData getPriorityIcon(String priorityName) {
  final details = getPriorityDetails(priorityName);
  return details?['icon'] ?? Icons.remove;
}

// Get priority label from priority name
String getPriorityLabel(String priorityName) {
  final details = getPriorityDetails(priorityName);
  return details?['label'] ?? 'Medium';
}

// Get list of priority names
List<String> getAvailablePriorityNames() {
  return availablePriorities.map((item) => item['name'] as String).toList();
}

// Get priority sort order (high=0, medium=1, low=2)
int getPrioritySortOrder(String priorityName) {
  final index = availablePriorities.indexWhere(
    (p) => p['name'] == priorityName.toLowerCase(),
  );
  return index >= 0 ? index : 1; // Default to medium
}
