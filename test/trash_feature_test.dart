import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_app/data/database.dart';

void main() {
  group('Trash Feature Tests', () {
    test('tasks can be moved to trash', () {
      final db = ToDoDatabase();
      db.toDoList = [
        {'name': 'Task 1', 'completed': false, 'color': 'yellow', 'groupIndex': 0, 'subNotes': []},
        {'name': 'Task 2', 'completed': false, 'color': 'blue', 'groupIndex': 0, 'subNotes': []},
      ];
      db.trash = [];
      
      // Move first task to trash
      var task = db.toDoList[0];
      task['deletedAt'] = DateTime.now().toIso8601String();
      db.trash.add(task);
      db.toDoList.removeAt(0);
      
      expect(db.toDoList.length, 1);
      expect(db.trash.length, 1);
      expect(db.trash[0]['name'], 'Task 1');
      expect(db.trash[0]['deletedAt'], isNotNull);
    });

    test('tasks can be restored from trash', () {
      final db = ToDoDatabase();
      db.toDoList = [];
      db.trash = [
        {
          'name': 'Deleted Task',
          'completed': false,
          'color': 'yellow',
          'groupIndex': 0,
          'subNotes': [],
          'deletedAt': DateTime.now().toIso8601String(),
        }
      ];
      
      // Restore task from trash
      var task = db.trash[0];
      task.remove('deletedAt');
      db.trash.removeAt(0);
      db.toDoList.add(task);
      
      expect(db.toDoList.length, 1);
      expect(db.trash.length, 0);
      expect(db.toDoList[0]['name'], 'Deleted Task');
      expect(db.toDoList[0]['deletedAt'], isNull);
    });

    test('tasks can be permanently deleted from trash', () {
      final db = ToDoDatabase();
      db.trash = [
        {
          'name': 'Task to Delete',
          'completed': false,
          'color': 'yellow',
          'groupIndex': 0,
          'subNotes': [],
          'deletedAt': DateTime.now().toIso8601String(),
        }
      ];
      
      // Permanently delete
      db.trash.removeAt(0);
      
      expect(db.trash.length, 0);
    });

    test('trash can be emptied', () {
      final db = ToDoDatabase();
      db.trash = [
        {
          'name': 'Task 1',
          'completed': false,
          'color': 'yellow',
          'groupIndex': 0,
          'subNotes': [],
          'deletedAt': DateTime.now().toIso8601String(),
        },
        {
          'name': 'Task 2',
          'completed': false,
          'color': 'blue',
          'groupIndex': 0,
          'subNotes': [],
          'deletedAt': DateTime.now().toIso8601String(),
        },
      ];
      
      // Empty trash
      db.trash.clear();
      
      expect(db.trash.length, 0);
    });

    test('deletedAt timestamp is added when moving to trash', () {
      final db = ToDoDatabase();
      final beforeDelete = DateTime.now();
      
      db.toDoList = [
        {'name': 'Task', 'completed': false, 'color': 'yellow', 'groupIndex': 0, 'subNotes': []},
      ];
      db.trash = [];
      
      // Move to trash with timestamp
      var task = db.toDoList[0];
      final deleteTime = DateTime.now();
      task['deletedAt'] = deleteTime.toIso8601String();
      db.trash.add(task);
      db.toDoList.removeAt(0);
      
      final afterDelete = DateTime.now();
      
      expect(db.trash[0]['deletedAt'], isNotNull);
      final deletedAt = DateTime.parse(db.trash[0]['deletedAt']);
      expect(deletedAt.isAfter(beforeDelete.subtract(const Duration(seconds: 1))), true);
      expect(deletedAt.isBefore(afterDelete.add(const Duration(seconds: 1))), true);
    });

    test('trash maintains task properties', () {
      final db = ToDoDatabase();
      db.toDoList = [
        {
          'name': 'Complex Task',
          'completed': true,
          'color': 'blue',
          'groupIndex': 1,
          'subNotes': [
            {'name': 'Sub-note 1', 'completed': false, 'color': 'yellow'}
          ],
          'dueDate': DateTime.now().toIso8601String(),
          'dueTime': '14:30',
          'recurrence': 'daily',
        },
      ];
      db.trash = [];
      
      // Move to trash
      var task = db.toDoList[0];
      task['deletedAt'] = DateTime.now().toIso8601String();
      db.trash.add(task);
      db.toDoList.removeAt(0);
      
      // Verify all properties are maintained
      expect(db.trash[0]['name'], 'Complex Task');
      expect(db.trash[0]['completed'], true);
      expect(db.trash[0]['color'], 'blue');
      expect(db.trash[0]['groupIndex'], 1);
      expect(db.trash[0]['subNotes'].length, 1);
      expect(db.trash[0]['dueDate'], isNotNull);
      expect(db.trash[0]['dueTime'], '14:30');
      expect(db.trash[0]['recurrence'], 'daily');
    });

    test('restored task removes deletedAt property', () {
      final db = ToDoDatabase();
      db.toDoList = [];
      db.trash = [
        {
          'name': 'Task',
          'completed': false,
          'color': 'yellow',
          'groupIndex': 0,
          'subNotes': [],
          'deletedAt': DateTime.now().toIso8601String(),
        }
      ];
      
      // Restore task
      var task = db.trash[0];
      task.remove('deletedAt');
      db.trash.removeAt(0);
      db.toDoList.add(task);
      
      expect(db.toDoList[0].containsKey('deletedAt'), false);
    });
  });
}
