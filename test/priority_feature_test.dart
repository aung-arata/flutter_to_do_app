import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_app/util/priority_utils.dart';
import 'package:to_do_app/data/database.dart';

void main() {
  group('Priority Suggestion Tests', () {
    test('suggest high priority for urgent keywords', () {
      expect(suggestPriority('urgent task'), 'high');
      expect(suggestPriority('ASAP work'), 'high');
      expect(suggestPriority('emergency fix'), 'high');
      expect(suggestPriority('critical issue'), 'high');
      expect(suggestPriority('important meeting'), 'high');
    });

    test('suggest high priority for tasks due within 2 days', () {
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      expect(suggestPriority('normal task', dueDate: tomorrow), 'high');
      
      final today = DateTime.now();
      expect(suggestPriority('normal task', dueDate: today), 'high');
    });

    test('suggest medium priority for tasks due within 7 days', () {
      final fiveDaysLater = DateTime.now().add(const Duration(days: 5));
      expect(suggestPriority('normal task', dueDate: fiveDaysLater), 'medium');
      
      final sevenDaysLater = DateTime.now().add(const Duration(days: 7));
      expect(suggestPriority('normal task', dueDate: sevenDaysLater), 'medium');
    });

    test('suggest medium priority for tasks without urgent keywords or near due dates', () {
      final farFuture = DateTime.now().add(const Duration(days: 30));
      expect(suggestPriority('normal task', dueDate: farFuture), 'medium');
      expect(suggestPriority('regular task'), 'medium');
    });

    test('urgent keywords override due date suggestion', () {
      final farFuture = DateTime.now().add(const Duration(days: 30));
      expect(suggestPriority('urgent task', dueDate: farFuture), 'high');
    });
  });

  group('Priority Statistics Tests', () {
    test('calculate priority statistics correctly', () {
      final db = ToDoDatabase();
      db.toDoList = [
        {'priority': 'high', 'completed': false},
        {'priority': 'high', 'completed': true},
        {'priority': 'medium', 'completed': false},
        {'priority': 'medium', 'completed': false},
        {'priority': 'low', 'completed': true},
      ];

      final stats = getPriorityStatistics(db.toDoList);
      
      expect(stats['high']!['count'], 2);
      expect(stats['high']!['completed'], 1);
      expect(stats['high']!['pending'], 1);
      
      expect(stats['medium']!['count'], 2);
      expect(stats['medium']!['completed'], 0);
      expect(stats['medium']!['pending'], 2);
      
      expect(stats['low']!['count'], 1);
      expect(stats['low']!['completed'], 1);
      expect(stats['low']!['pending'], 0);
    });

    test('handle tasks without priority field', () {
      final db = ToDoDatabase();
      db.toDoList = [
        {'name': 'task without priority', 'completed': false},
      ];

      final stats = getPriorityStatistics(db.toDoList);
      expect(stats['medium']!['count'], 1); // Default is medium
    });

    test('handle empty task list', () {
      final stats = getPriorityStatistics([]);
      expect(stats['high']!['count'], 0);
      expect(stats['medium']!['count'], 0);
      expect(stats['low']!['count'], 0);
    });
  });

  group('High Priority Recommendations Tests', () {
    test('return only high priority incomplete tasks', () {
      final db = ToDoDatabase();
      db.toDoList = [
        {'name': 'Task 1', 'priority': 'high', 'completed': false},
        {'name': 'Task 2', 'priority': 'high', 'completed': true},
        {'name': 'Task 3', 'priority': 'medium', 'completed': false},
        {'name': 'Task 4', 'priority': 'high', 'completed': false},
      ];

      final recommendations = getHighPriorityRecommendations(db.toDoList);
      expect(recommendations.length, 2);
      expect(recommendations[0]['name'], 'Task 1');
      expect(recommendations[1]['name'], 'Task 4');
    });

    test('sort recommendations by due date', () {
      final now = DateTime.now();
      final db = ToDoDatabase();
      db.toDoList = [
        {
          'name': 'Task Later',
          'priority': 'high',
          'completed': false,
          'dueDate': now.add(const Duration(days: 5)).toIso8601String(),
        },
        {
          'name': 'Task Soon',
          'priority': 'high',
          'completed': false,
          'dueDate': now.add(const Duration(days: 1)).toIso8601String(),
        },
        {
          'name': 'Task No Date',
          'priority': 'high',
          'completed': false,
          'dueDate': null,
        },
      ];

      final recommendations = getHighPriorityRecommendations(db.toDoList);
      expect(recommendations[0]['name'], 'Task Soon');
      expect(recommendations[1]['name'], 'Task Later');
      expect(recommendations[2]['name'], 'Task No Date');
    });

    test('return empty list when no high priority tasks', () {
      final db = ToDoDatabase();
      db.toDoList = [
        {'name': 'Task 1', 'priority': 'medium', 'completed': false},
        {'name': 'Task 2', 'priority': 'low', 'completed': false},
      ];

      final recommendations = getHighPriorityRecommendations(db.toDoList);
      expect(recommendations, isEmpty);
    });
  });

  group('Tasks Needing Priority Update Tests', () {
    test('identify low priority tasks due soon', () {
      final now = DateTime.now();
      final db = ToDoDatabase();
      db.toDoList = [
        {
          'name': 'Low Priority Due Soon',
          'priority': 'low',
          'completed': false,
          'dueDate': now.add(const Duration(days: 2)).toIso8601String(),
        },
      ];

      final needsUpdate = getTasksNeedingPriorityUpdate(db.toDoList);
      expect(needsUpdate.length, 1);
      expect(needsUpdate[0]['suggestedPriority'], 'high');
    });

    test('identify medium priority tasks due very soon', () {
      final now = DateTime.now();
      final db = ToDoDatabase();
      db.toDoList = [
        {
          'name': 'Medium Priority Due Tomorrow',
          'priority': 'medium',
          'completed': false,
          'dueDate': now.add(const Duration(days: 1)).toIso8601String(),
        },
      ];

      final needsUpdate = getTasksNeedingPriorityUpdate(db.toDoList);
      expect(needsUpdate.length, 1);
      expect(needsUpdate[0]['suggestedPriority'], 'high');
    });

    test('do not suggest updates for completed tasks', () {
      final now = DateTime.now();
      final db = ToDoDatabase();
      db.toDoList = [
        {
          'name': 'Completed Low Priority',
          'priority': 'low',
          'completed': true,
          'dueDate': now.add(const Duration(days: 1)).toIso8601String(),
        },
      ];

      final needsUpdate = getTasksNeedingPriorityUpdate(db.toDoList);
      expect(needsUpdate, isEmpty);
    });

    test('do not suggest updates for tasks without due dates', () {
      final db = ToDoDatabase();
      db.toDoList = [
        {
          'name': 'Low Priority No Date',
          'priority': 'low',
          'completed': false,
          'dueDate': null,
        },
      ];

      final needsUpdate = getTasksNeedingPriorityUpdate(db.toDoList);
      expect(needsUpdate, isEmpty);
    });
  });

  group('Priority Recommendation Message Tests', () {
    test('return appropriate message for no high priority tasks', () {
      final db = ToDoDatabase();
      db.toDoList = [
        {'priority': 'medium', 'completed': false},
      ];

      final message = getPriorityRecommendationMessage(db.toDoList);
      expect(message, contains('Great'));
    });

    test('return appropriate message for one high priority task', () {
      final db = ToDoDatabase();
      db.toDoList = [
        {'priority': 'high', 'completed': false},
      ];

      final message = getPriorityRecommendationMessage(db.toDoList);
      expect(message, contains('1 high-priority task'));
    });

    test('return appropriate message for multiple high priority tasks', () {
      final db = ToDoDatabase();
      db.toDoList = [
        {'priority': 'high', 'completed': false},
        {'priority': 'high', 'completed': false},
        {'priority': 'high', 'completed': false},
      ];

      final message = getPriorityRecommendationMessage(db.toDoList);
      expect(message, contains('3 high-priority tasks'));
    });
  });
}
