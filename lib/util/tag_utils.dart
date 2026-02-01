import 'package:flutter/material.dart';

// Predefined common tags
const List<String> commonTags = [
  'urgent',
  'waiting',
  'home',
  'office',
  'personal',
  'work',
  'important',
  'review',
  'followup',
  'meeting',
  'call',
  'email',
  'shopping',
  'health',
  'finance',
];

// Tag suggestion based on task name using keyword matching
List<String> suggestTags(String taskName) {
  final suggestions = <String>[];
  final lowerTaskName = taskName.toLowerCase();
  
  // Keyword mapping for tag suggestions
  final keywordMapping = {
    'urgent': ['urgent', 'asap', 'emergency', 'critical'],
    'meeting': ['meeting', 'meet', 'conference', 'call'],
    'email': ['email', 'mail', 'send', 'reply'],
    'call': ['call', 'phone', 'contact'],
    'shopping': ['buy', 'shop', 'purchase', 'order'],
    'home': ['home', 'house', 'apartment'],
    'office': ['office', 'work'],
    'health': ['health', 'doctor', 'appointment', 'exercise', 'gym'],
    'finance': ['pay', 'bill', 'bank', 'money', 'budget'],
    'important': ['important', 'priority', 'key', 'essential'],
    'review': ['review', 'check', 'verify', 'audit'],
    'followup': ['followup', 'follow up', 'follow-up', 'remind'],
  };
  
  // Check each keyword mapping
  keywordMapping.forEach((tag, keywords) {
    for (var keyword in keywords) {
      if (lowerTaskName.contains(keyword)) {
        if (!suggestions.contains(tag)) {
          suggestions.add(tag);
        }
        break;
      }
    }
  });
  
  return suggestions;
}

// Get tag color based on tag name
Color getTagColor(String tag) {
  final lowerTag = tag.toLowerCase();
  
  switch (lowerTag) {
    case 'urgent':
    case 'important':
      return Colors.red.shade300;
    case 'waiting':
    case 'followup':
      return Colors.orange.shade300;
    case 'home':
    case 'personal':
      return Colors.blue.shade300;
    case 'office':
    case 'work':
      return Colors.purple.shade300;
    case 'meeting':
    case 'call':
      return Colors.teal.shade300;
    case 'email':
      return Colors.indigo.shade300;
    case 'shopping':
      return Colors.pink.shade300;
    case 'health':
      return Colors.green.shade300;
    case 'finance':
      return Colors.amber.shade300;
    case 'review':
      return Colors.cyan.shade300;
    default:
      return Colors.grey.shade300;
  }
}

// Get tag statistics from task list
Map<String, int> getTagStatistics(List tasks) {
  final tagStats = <String, int>{};
  
  for (var task in tasks) {
    if (task is Map && task.containsKey('tags') && task['tags'] is List) {
      final tags = task['tags'] as List;
      for (var tag in tags) {
        if (tag is String) {
          tagStats[tag] = (tagStats[tag] ?? 0) + 1;
        }
      }
    }
  }
  
  return tagStats;
}

// Get most frequently used tags
List<String> getFrequentTags(List tasks, {int limit = 5}) {
  final tagStats = getTagStatistics(tasks);
  
  // Sort by count and return top tags
  final sortedTags = tagStats.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  
  return sortedTags
    .take(limit)
    .map((entry) => entry.key)
    .toList();
}

// Filter tasks by tag
List filterTasksByTag(List tasks, String tag) {
  return tasks.where((task) {
    if (task is Map && task.containsKey('tags') && task['tags'] is List) {
      final tags = task['tags'] as List;
      return tags.any((t) => t.toString().toLowerCase() == tag.toLowerCase());
    }
    return false;
  }).toList();
}

// Filter tasks by multiple tags (AND operation)
List filterTasksByTags(List tasks, List<String> tags) {
  return tasks.where((task) {
    if (task is Map && task.containsKey('tags') && task['tags'] is List) {
      final taskTags = task['tags'] as List;
      // Check if all specified tags are present
      return tags.every((tag) => 
        taskTags.any((t) => t.toString().toLowerCase() == tag.toLowerCase())
      );
    }
    return false;
  }).toList();
}
