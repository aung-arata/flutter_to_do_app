import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_app/util/tag_utils.dart';

void main() {
  group('Tag Suggestion Tests', () {
    test('suggest urgent tag for urgent keywords', () {
      expect(suggestTags('urgent meeting'), contains('urgent'));
      expect(suggestTags('ASAP task'), contains('urgent'));
      expect(suggestTags('emergency fix'), contains('urgent'));
    });

    test('suggest meeting tag for meeting keywords', () {
      expect(suggestTags('team meeting tomorrow'), contains('meeting'));
      expect(suggestTags('conference call'), contains('meeting'));
      expect(suggestTags('meet with client'), contains('meeting'));
    });

    test('suggest shopping tag for shopping keywords', () {
      expect(suggestTags('buy groceries'), contains('shopping'));
      expect(suggestTags('shop for clothes'), contains('shopping'));
      expect(suggestTags('purchase new laptop'), contains('shopping'));
    });

    test('suggest email tag for email keywords', () {
      expect(suggestTags('send email to boss'), contains('email'));
      expect(suggestTags('reply to mail'), contains('email'));
    });

    test('suggest health tag for health keywords', () {
      expect(suggestTags('doctor appointment'), contains('health'));
      expect(suggestTags('exercise routine'), contains('health'));
      expect(suggestTags('gym session'), contains('health'));
    });

    test('suggest multiple tags for complex task names', () {
      final tags = suggestTags('urgent email to doctor about appointment');
      expect(tags, contains('urgent'));
      expect(tags, contains('email'));
      expect(tags, contains('health'));
    });

    test('return empty list for tasks with no matching keywords', () {
      expect(suggestTags('random task'), isEmpty);
      expect(suggestTags('some work'), isEmpty);
    });

    test('case insensitive matching', () {
      expect(suggestTags('URGENT EMAIL'), contains('urgent'));
      expect(suggestTags('Buy Groceries'), contains('shopping'));
    });
  });

  group('Tag Statistics Tests', () {
    test('count tags correctly', () {
      final tasks = [
        {'tags': ['urgent', 'work']},
        {'tags': ['urgent', 'email']},
        {'tags': ['home']},
      ];

      final stats = getTagStatistics(tasks);
      expect(stats['urgent'], 2);
      expect(stats['work'], 1);
      expect(stats['email'], 1);
      expect(stats['home'], 1);
    });

    test('handle tasks without tags', () {
      final tasks = [
        {'tags': ['urgent']},
        {'name': 'task without tags'},
      ];

      final stats = getTagStatistics(tasks);
      expect(stats['urgent'], 1);
      expect(stats.length, 1);
    });

    test('handle empty task list', () {
      final stats = getTagStatistics([]);
      expect(stats, isEmpty);
    });
  });

  group('Frequent Tags Tests', () {
    test('return most frequently used tags', () {
      final tasks = [
        {'tags': ['urgent', 'work']},
        {'tags': ['urgent', 'email']},
        {'tags': ['urgent', 'home']},
        {'tags': ['work', 'email']},
        {'tags': ['home']},
      ];

      final frequentTags = getFrequentTags(tasks, limit: 3);
      expect(frequentTags[0], 'urgent'); // 3 occurrences
      expect(frequentTags.length, lessThanOrEqualTo(3));
    });

    test('respect limit parameter', () {
      final tasks = [
        {'tags': ['a', 'b', 'c']},
        {'tags': ['d', 'e', 'f']},
      ];

      final frequentTags = getFrequentTags(tasks, limit: 2);
      expect(frequentTags.length, lessThanOrEqualTo(2));
    });
  });

  group('Tag Filtering Tests', () {
    test('filter tasks by single tag', () {
      final tasks = [
        {'name': 'Task 1', 'tags': ['urgent', 'work']},
        {'name': 'Task 2', 'tags': ['email']},
        {'name': 'Task 3', 'tags': ['urgent', 'home']},
      ];

      final filtered = filterTasksByTag(tasks, 'urgent');
      expect(filtered.length, 2);
      expect(filtered[0]['name'], 'Task 1');
      expect(filtered[1]['name'], 'Task 3');
    });

    test('filter is case insensitive', () {
      final tasks = [
        {'name': 'Task 1', 'tags': ['Urgent']},
      ];

      final filtered = filterTasksByTag(tasks, 'urgent');
      expect(filtered.length, 1);
    });

    test('filter tasks by multiple tags', () {
      final tasks = [
        {'name': 'Task 1', 'tags': ['urgent', 'work', 'email']},
        {'name': 'Task 2', 'tags': ['urgent', 'work']},
        {'name': 'Task 3', 'tags': ['urgent']},
      ];

      final filtered = filterTasksByTags(tasks, ['urgent', 'work']);
      expect(filtered.length, 2);
      expect(filtered[0]['name'], 'Task 1');
      expect(filtered[1]['name'], 'Task 2');
    });

    test('return empty list when no tasks match tag', () {
      final tasks = [
        {'name': 'Task 1', 'tags': ['work']},
      ];

      final filtered = filterTasksByTag(tasks, 'urgent');
      expect(filtered, isEmpty);
    });
  });
}
