import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_app/util/category_utils.dart';

void main() {
  group('Category Suggestion Tests', () {
    test('suggest Shopping category for shopping keywords', () {
      expect(suggestCategory('buy groceries'), 'Shopping');
      expect(suggestCategory('shop for clothes'), 'Shopping');
      expect(suggestCategory('purchase new laptop'), 'Shopping');
      expect(suggestCategory('order online'), 'Shopping');
    });

    test('suggest Work category for work keywords', () {
      expect(suggestCategory('finish work task'), 'Work');
      expect(suggestCategory('office meeting'), 'Work');
      expect(suggestCategory('project deadline'), 'Work');
    });

    test('suggest Health category for health keywords', () {
      expect(suggestCategory('doctor appointment'), 'Health');
      expect(suggestCategory('exercise routine'), 'Health');
      expect(suggestCategory('gym session'), 'Health');
      expect(suggestCategory('workout plan'), 'Health');
    });

    test('suggest Finance category for finance keywords', () {
      expect(suggestCategory('pay bills'), 'Finance');
      expect(suggestCategory('bank transfer'), 'Finance');
      expect(suggestCategory('budget review'), 'Finance');
    });

    test('suggest Education category for education keywords', () {
      expect(suggestCategory('study for exam'), 'Education');
      expect(suggestCategory('complete homework'), 'Education');
      expect(suggestCategory('learn new course'), 'Education');
    });

    test('suggest Home category for home keywords', () {
      expect(suggestCategory('clean the house'), 'Home');
      expect(suggestCategory('repair apartment'), 'Home');
      expect(suggestCategory('home maintenance'), 'Home');
    });

    test('suggest Social category for social keywords', () {
      expect(suggestCategory('visit friend'), 'Social');
      expect(suggestCategory('family party'), 'Social');
      expect(suggestCategory('social event'), 'Social');
    });

    test('return null for tasks with no matching keywords', () {
      expect(suggestCategory('random task'), isNull);
      expect(suggestCategory('some generic work'), isNotNull); // 'work' keyword
    });

    test('case insensitive matching', () {
      expect(suggestCategory('BUY groceries'), 'Shopping');
      expect(suggestCategory('DOCTOR appointment'), 'Health');
    });

    test('first matching category is returned', () {
      // 'work' keyword appears in both Work and other possible matches
      final result = suggestCategory('work project');
      expect(result, isNotNull);
    });
  });

  group('Category Statistics Tests', () {
    test('count categories correctly', () {
      final tasks = [
        {'category': 'Shopping'},
        {'category': 'Shopping'},
        {'category': 'Work'},
        {'category': 'Health'},
      ];

      final stats = getCategoryStatistics(tasks);
      expect(stats['Shopping'], 2);
      expect(stats['Work'], 1);
      expect(stats['Health'], 1);
    });

    test('handle tasks without category', () {
      final tasks = [
        {'category': 'Shopping'},
        {'name': 'task without category'},
        {'category': null},
      ];

      final stats = getCategoryStatistics(tasks);
      expect(stats['Shopping'], 1);
      expect(stats.length, 1);
    });

    test('handle empty task list', () {
      final stats = getCategoryStatistics([]);
      expect(stats, isEmpty);
    });
  });

  group('Frequent Categories Tests', () {
    test('return most frequently used categories', () {
      final tasks = [
        {'category': 'Shopping'},
        {'category': 'Shopping'},
        {'category': 'Shopping'},
        {'category': 'Work'},
        {'category': 'Work'},
        {'category': 'Health'},
      ];

      final frequentCategories = getFrequentCategories(tasks, limit: 3);
      expect(frequentCategories[0], 'Shopping'); // 3 occurrences
      expect(frequentCategories[1], 'Work'); // 2 occurrences
      expect(frequentCategories.length, lessThanOrEqualTo(3));
    });

    test('respect limit parameter', () {
      final tasks = [
        {'category': 'Shopping'},
        {'category': 'Work'},
        {'category': 'Health'},
      ];

      final frequentCategories = getFrequentCategories(tasks, limit: 2);
      expect(frequentCategories.length, lessThanOrEqualTo(2));
    });
  });

  group('Category Filtering Tests', () {
    test('filter tasks by category', () {
      final tasks = [
        {'name': 'Task 1', 'category': 'Shopping'},
        {'name': 'Task 2', 'category': 'Work'},
        {'name': 'Task 3', 'category': 'Shopping'},
      ];

      final filtered = filterTasksByCategory(tasks, 'Shopping');
      expect(filtered.length, 2);
      expect(filtered[0]['name'], 'Task 1');
      expect(filtered[1]['name'], 'Task 3');
    });

    test('filter is case insensitive', () {
      final tasks = [
        {'name': 'Task 1', 'category': 'Shopping'},
      ];

      final filtered = filterTasksByCategory(tasks, 'shopping');
      expect(filtered.length, 1);
    });

    test('return empty list when no tasks match category', () {
      final tasks = [
        {'name': 'Task 1', 'category': 'Work'},
      ];

      final filtered = filterTasksByCategory(tasks, 'Shopping');
      expect(filtered, isEmpty);
    });

    test('handle tasks with null category', () {
      final tasks = [
        {'name': 'Task 1', 'category': null},
        {'name': 'Task 2', 'category': 'Shopping'},
      ];

      final filtered = filterTasksByCategory(tasks, 'Shopping');
      expect(filtered.length, 1);
    });
  });

  group('Category Template Tests', () {
    test('return template tasks for Shopping category', () {
      final template = getCategoryTemplate('Shopping');
      expect(template, isNotEmpty);
      expect(template, contains('Buy groceries'));
    });

    test('return template tasks for Work category', () {
      final template = getCategoryTemplate('Work');
      expect(template, isNotEmpty);
      expect(template, contains('Check emails'));
    });

    test('return template tasks for Health category', () {
      final template = getCategoryTemplate('Health');
      expect(template, isNotEmpty);
      expect(template, contains('Exercise for 30 minutes'));
    });

    test('return empty list for unknown category', () {
      final template = getCategoryTemplate('Unknown');
      expect(template, isEmpty);
    });
  });
}
