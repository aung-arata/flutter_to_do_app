import 'package:flutter/material.dart';

// Predefined categories with icons and colors
const List<Map<String, dynamic>> predefinedCategories = [
  {
    'name': 'Shopping',
    'icon': Icons.shopping_cart,
    'color': Colors.pink,
    'keywords': ['buy', 'shop', 'purchase', 'order', 'store'],
  },
  {
    'name': 'Work',
    'icon': Icons.work,
    'color': Colors.blue,
    'keywords': ['work', 'job', 'office', 'project', 'task', 'meeting'],
  },
  {
    'name': 'Personal',
    'icon': Icons.person,
    'color': Colors.purple,
    'keywords': ['personal', 'self', 'me', 'my'],
  },
  {
    'name': 'Health',
    'icon': Icons.health_and_safety,
    'color': Colors.green,
    'keywords': ['health', 'doctor', 'appointment', 'exercise', 'gym', 'workout', 'fitness'],
  },
  {
    'name': 'Finance',
    'icon': Icons.attach_money,
    'color': Colors.amber,
    'keywords': ['pay', 'bill', 'bank', 'money', 'budget', 'finance', 'payment'],
  },
  {
    'name': 'Education',
    'icon': Icons.school,
    'color': Colors.indigo,
    'keywords': ['study', 'learn', 'course', 'class', 'education', 'homework', 'assignment'],
  },
  {
    'name': 'Home',
    'icon': Icons.home,
    'color': Colors.teal,
    'keywords': ['home', 'house', 'apartment', 'cleaning', 'repair', 'maintenance'],
  },
  {
    'name': 'Social',
    'icon': Icons.people,
    'color': Colors.orange,
    'keywords': ['friend', 'family', 'social', 'party', 'event', 'visit'],
  },
];

// Auto-categorize task based on keywords in task name
String? suggestCategory(String taskName) {
  final lowerTaskName = taskName.toLowerCase();
  
  for (var category in predefinedCategories) {
    final keywords = category['keywords'] as List;
    for (var keyword in keywords) {
      if (lowerTaskName.contains(keyword.toString().toLowerCase())) {
        return category['name'] as String;
      }
    }
  }
  
  return null;
}

// Get category details
Map<String, dynamic>? getCategoryDetails(String categoryName) {
  try {
    return predefinedCategories.firstWhere(
      (cat) => cat['name'].toString().toLowerCase() == categoryName.toLowerCase(),
    );
  } catch (e) {
    return null;
  }
}

// Get category color
Color getCategoryColor(String categoryName) {
  final details = getCategoryDetails(categoryName);
  if (details != null) {
    return details['color'] as Color;
  }
  return Colors.grey;
}

// Get category icon
IconData getCategoryIcon(String categoryName) {
  final details = getCategoryDetails(categoryName);
  if (details != null) {
    return details['icon'] as IconData;
  }
  return Icons.category;
}

// Get category statistics from task list
Map<String, int> getCategoryStatistics(List tasks) {
  final categoryStats = <String, int>{};
  
  for (var task in tasks) {
    if (task is Map && task.containsKey('category') && task['category'] != null) {
      final category = task['category'] as String;
      categoryStats[category] = (categoryStats[category] ?? 0) + 1;
    }
  }
  
  return categoryStats;
}

// Get frequently used categories
List<String> getFrequentCategories(List tasks, {int limit = 5}) {
  final categoryStats = getCategoryStatistics(tasks);
  
  // Sort by count and return top categories
  final sortedCategories = categoryStats.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  
  return sortedCategories
    .take(limit)
    .map((entry) => entry.key)
    .toList();
}

// Filter tasks by category
List filterTasksByCategory(List tasks, String category) {
  return tasks.where((task) {
    if (task is Map && task.containsKey('category')) {
      return task['category']?.toString().toLowerCase() == category.toLowerCase();
    }
    return false;
  }).toList();
}

// Category templates with predefined task lists
final Map<String, List<String>> categoryTemplates = {
  'Shopping': [
    'Buy groceries',
    'Purchase household items',
    'Order online',
  ],
  'Work': [
    'Check emails',
    'Prepare presentation',
    'Attend team meeting',
    'Complete project tasks',
  ],
  'Health': [
    'Schedule doctor appointment',
    'Take medication',
    'Exercise for 30 minutes',
    'Track calories',
  ],
  'Finance': [
    'Pay bills',
    'Review budget',
    'Check bank statements',
    'File expenses',
  ],
  'Education': [
    'Study for exam',
    'Complete assignment',
    'Read chapter',
    'Attend class',
  ],
  'Home': [
    'Clean the house',
    'Do laundry',
    'Water plants',
    'Take out trash',
  ],
};

// Get template tasks for a category
List<String> getCategoryTemplate(String categoryName) {
  return categoryTemplates[categoryName] ?? [];
}
