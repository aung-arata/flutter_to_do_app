import 'package:flutter/material.dart';
import 'package:to_do_app/util/date_utils.dart' as date_utils;

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

// Auto-suggest priority based on due date and keywords
String suggestPriority(String taskName, {DateTime? dueDate}) {
  final lowerTaskName = taskName.toLowerCase();
  
  // Check for urgent keywords
  final urgentKeywords = [
    'urgent', 'asap', 'emergency', 'critical', 'important', 
    'priority', 'deadline', 'immediately', 'now'
  ];
  
  for (var keyword in urgentKeywords) {
    if (lowerTaskName.contains(keyword)) {
      return 'high';
    }
  }
  
  // Check due date proximity
  if (dueDate != null) {
    final now = DateTime.now();
    final daysUntilDue = dueDate.difference(now).inDays;
    
    // If due within 2 days, suggest high priority
    if (daysUntilDue <= 2) {
      return 'high';
    }
    // If due within 7 days, suggest medium priority
    else if (daysUntilDue <= 7) {
      return 'medium';
    }
  }
  
  // Default to medium priority
  return 'medium';
}

// Get priority statistics from task list
Map<String, Map<String, dynamic>> getPriorityStatistics(List tasks) {
  final stats = {
    'high': {'count': 0, 'completed': 0, 'pending': 0},
    'medium': {'count': 0, 'completed': 0, 'pending': 0},
    'low': {'count': 0, 'completed': 0, 'pending': 0},
  };
  
  for (var task in tasks) {
    if (task is Map) {
      final priority = (task['priority'] ?? 'medium').toString().toLowerCase();
      final completed = task['completed'] ?? false;
      
      if (stats.containsKey(priority)) {
        stats[priority]!['count'] = (stats[priority]!['count'] as int) + 1;
        if (completed) {
          stats[priority]!['completed'] = (stats[priority]!['completed'] as int) + 1;
        } else {
          stats[priority]!['pending'] = (stats[priority]!['pending'] as int) + 1;
        }
      }
    }
  }
  
  return stats;
}

// Get high priority tasks that should be focused on
List getHighPriorityRecommendations(List tasks) {
  final now = DateTime.now();
  
  // Filter for high priority incomplete tasks
  final highPriorityTasks = tasks.where((task) {
    if (task is Map) {
      final priority = (task['priority'] ?? 'medium').toString().toLowerCase();
      final completed = task['completed'] ?? false;
      return priority == 'high' && !completed;
    }
    return false;
  }).toList();
  
  // Sort by due date (earliest first)
  highPriorityTasks.sort((a, b) {
    final dateA = date_utils.parseDateTimeSafe(a['dueDate']);
    final dateB = date_utils.parseDateTimeSafe(b['dueDate']);
    
    if (dateA == null && dateB == null) return 0;
    if (dateA == null) return 1;
    if (dateB == null) return -1;
    return dateA.compareTo(dateB);
  });
  
  return highPriorityTasks;
}

// Get tasks that may need priority update
List getTasksNeedingPriorityUpdate(List tasks) {
  final now = DateTime.now();
  final needsUpdate = <Map<String, dynamic>>[];
  
  for (var task in tasks) {
    if (task is Map) {
      final priority = (task['priority'] ?? 'medium').toString().toLowerCase();
      final completed = task['completed'] ?? false;
      final dueDate = date_utils.parseDateTimeSafe(task['dueDate']);
      
      if (!completed && dueDate != null) {
        final daysUntilDue = dueDate.difference(now).inDays;
        
        // Low priority task due soon should be upgraded
        if (priority == 'low' && daysUntilDue <= 3) {
          needsUpdate.add({
            'task': task,
            'suggestedPriority': 'high',
            'reason': 'Due in $daysUntilDue days',
          });
        }
        // Medium priority task due very soon
        else if (priority == 'medium' && daysUntilDue <= 1) {
          needsUpdate.add({
            'task': task,
            'suggestedPriority': 'high',
            'reason': 'Due in $daysUntilDue days',
          });
        }
      }
    }
  }
  
  return needsUpdate;
}

// Get priority-based task recommendation message
String getPriorityRecommendationMessage(List tasks) {
  final highPriorityTasks = getHighPriorityRecommendations(tasks);
  
  if (highPriorityTasks.isEmpty) {
    return 'Great! No high-priority tasks at the moment.';
  } else if (highPriorityTasks.length == 1) {
    return 'Focus on 1 high-priority task first!';
  } else {
    return 'Focus on ${highPriorityTasks.length} high-priority tasks first!';
  }
}

