import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_app/data/database.dart';
import 'package:to_do_app/util/date_utils.dart' as date_utils;

void main() {
  group('Filter Feature Tests', () {
    test('filter by completion status - completed only', () {
      final db = ToDoDatabase();
      db.toDoList = [
        {'name': 'Task 1', 'completed': true, 'color': 'yellow', 'groupIndex': 0, 'subNotes': []},
        {'name': 'Task 2', 'completed': false, 'color': 'blue', 'groupIndex': 0, 'subNotes': []},
        {'name': 'Task 3', 'completed': true, 'color': 'red', 'groupIndex': 0, 'subNotes': []},
      ];
      
      // Filter completed tasks
      var completedTasks = db.toDoList.where((task) => task['completed'] == true).toList();
      
      expect(completedTasks.length, 2);
      expect(completedTasks[0]['name'], 'Task 1');
      expect(completedTasks[1]['name'], 'Task 3');
    });

    test('filter by completion status - incomplete only', () {
      final db = ToDoDatabase();
      db.toDoList = [
        {'name': 'Task 1', 'completed': true, 'color': 'yellow', 'groupIndex': 0, 'subNotes': []},
        {'name': 'Task 2', 'completed': false, 'color': 'blue', 'groupIndex': 0, 'subNotes': []},
        {'name': 'Task 3', 'completed': false, 'color': 'red', 'groupIndex': 0, 'subNotes': []},
      ];
      
      // Filter incomplete tasks
      var incompleteTasks = db.toDoList.where((task) => task['completed'] == false).toList();
      
      expect(incompleteTasks.length, 2);
      expect(incompleteTasks[0]['name'], 'Task 2');
      expect(incompleteTasks[1]['name'], 'Task 3');
    });

    test('filter by color', () {
      final db = ToDoDatabase();
      db.toDoList = [
        {'name': 'Task 1', 'completed': false, 'color': 'yellow', 'groupIndex': 0, 'subNotes': []},
        {'name': 'Task 2', 'completed': false, 'color': 'blue', 'groupIndex': 0, 'subNotes': []},
        {'name': 'Task 3', 'completed': false, 'color': 'blue', 'groupIndex': 0, 'subNotes': []},
      ];
      
      // Filter by blue color
      var blueTasks = db.toDoList.where((task) => task['color'] == 'blue').toList();
      
      expect(blueTasks.length, 2);
      expect(blueTasks[0]['name'], 'Task 2');
      expect(blueTasks[1]['name'], 'Task 3');
    });

    test('combined filter - completed and specific color', () {
      final db = ToDoDatabase();
      db.toDoList = [
        {'name': 'Task 1', 'completed': true, 'color': 'blue', 'groupIndex': 0, 'subNotes': []},
        {'name': 'Task 2', 'completed': false, 'color': 'blue', 'groupIndex': 0, 'subNotes': []},
        {'name': 'Task 3', 'completed': true, 'color': 'red', 'groupIndex': 0, 'subNotes': []},
      ];
      
      // Filter completed blue tasks
      var filteredTasks = db.toDoList.where((task) => 
        task['completed'] == true && task['color'] == 'blue'
      ).toList();
      
      expect(filteredTasks.length, 1);
      expect(filteredTasks[0]['name'], 'Task 1');
    });

    test('filter by group', () {
      final db = ToDoDatabase();
      db.toDoList = [
        {'name': 'Task 1', 'completed': false, 'color': 'yellow', 'groupIndex': 0, 'subNotes': []},
        {'name': 'Task 2', 'completed': false, 'color': 'blue', 'groupIndex': 1, 'subNotes': []},
        {'name': 'Task 3', 'completed': false, 'color': 'red', 'groupIndex': 0, 'subNotes': []},
      ];
      
      // Filter by group 0
      var group0Tasks = db.toDoList.where((task) => task['groupIndex'] == 0).toList();
      
      expect(group0Tasks.length, 2);
      expect(group0Tasks[0]['name'], 'Task 1');
      expect(group0Tasks[1]['name'], 'Task 3');
    });
  });

  group('Sort Feature Tests', () {
    test('sort by name alphabetically', () {
      final db = ToDoDatabase();
      db.toDoList = [
        {'name': 'Zebra', 'completed': false, 'color': 'yellow', 'groupIndex': 0, 'subNotes': []},
        {'name': 'Apple', 'completed': false, 'color': 'blue', 'groupIndex': 0, 'subNotes': []},
        {'name': 'Mango', 'completed': false, 'color': 'red', 'groupIndex': 0, 'subNotes': []},
      ];
      
      // Sort by name
      db.toDoList.sort((a, b) => 
        (a['name'] as String).toLowerCase().compareTo((b['name'] as String).toLowerCase())
      );
      
      expect(db.toDoList[0]['name'], 'Apple');
      expect(db.toDoList[1]['name'], 'Mango');
      expect(db.toDoList[2]['name'], 'Zebra');
    });

    test('sort by completion status - incomplete first', () {
      final db = ToDoDatabase();
      db.toDoList = [
        {'name': 'Task 1', 'completed': true, 'color': 'yellow', 'groupIndex': 0, 'subNotes': []},
        {'name': 'Task 2', 'completed': false, 'color': 'blue', 'groupIndex': 0, 'subNotes': []},
        {'name': 'Task 3', 'completed': true, 'color': 'red', 'groupIndex': 0, 'subNotes': []},
        {'name': 'Task 4', 'completed': false, 'color': 'green', 'groupIndex': 0, 'subNotes': []},
      ];
      
      // Sort by completion (incomplete first)
      db.toDoList.sort((a, b) {
        bool completedA = a['completed'] ?? false;
        bool completedB = b['completed'] ?? false;
        return completedA == completedB ? 0 : (completedA ? 1 : -1);
      });
      
      expect(db.toDoList[0]['completed'], false);
      expect(db.toDoList[1]['completed'], false);
      expect(db.toDoList[2]['completed'], true);
      expect(db.toDoList[3]['completed'], true);
    });

    test('sort handles case-insensitive names', () {
      final db = ToDoDatabase();
      db.toDoList = [
        {'name': 'ZEBRA', 'completed': false, 'color': 'yellow', 'groupIndex': 0, 'subNotes': []},
        {'name': 'apple', 'completed': false, 'color': 'blue', 'groupIndex': 0, 'subNotes': []},
        {'name': 'Mango', 'completed': false, 'color': 'red', 'groupIndex': 0, 'subNotes': []},
      ];
      
      // Sort by name (case-insensitive)
      db.toDoList.sort((a, b) => 
        (a['name'] as String).toLowerCase().compareTo((b['name'] as String).toLowerCase())
      );
      
      expect(db.toDoList[0]['name'], 'apple');
      expect(db.toDoList[1]['name'], 'Mango');
      expect(db.toDoList[2]['name'], 'ZEBRA');
    });
  });

  group('Combined Filter and Sort Tests', () {
    test('filter incomplete tasks and sort by name', () {
      final db = ToDoDatabase();
      db.toDoList = [
        {'name': 'Zebra', 'completed': true, 'color': 'yellow', 'groupIndex': 0, 'subNotes': []},
        {'name': 'Apple', 'completed': false, 'color': 'blue', 'groupIndex': 0, 'subNotes': []},
        {'name': 'Mango', 'completed': false, 'color': 'red', 'groupIndex': 0, 'subNotes': []},
        {'name': 'Banana', 'completed': true, 'color': 'yellow', 'groupIndex': 0, 'subNotes': []},
      ];
      
      // Filter incomplete
      var filtered = db.toDoList.where((task) => task['completed'] == false).toList();
      
      // Sort by name
      filtered.sort((a, b) => 
        (a['name'] as String).toLowerCase().compareTo((b['name'] as String).toLowerCase())
      );
      
      expect(filtered.length, 2);
      expect(filtered[0]['name'], 'Apple');
      expect(filtered[1]['name'], 'Mango');
    });

    test('filter by color and sort by completion status', () {
      final db = ToDoDatabase();
      db.toDoList = [
        {'name': 'Task 1', 'completed': true, 'color': 'blue', 'groupIndex': 0, 'subNotes': []},
        {'name': 'Task 2', 'completed': false, 'color': 'blue', 'groupIndex': 0, 'subNotes': []},
        {'name': 'Task 3', 'completed': false, 'color': 'red', 'groupIndex': 0, 'subNotes': []},
        {'name': 'Task 4', 'completed': true, 'color': 'blue', 'groupIndex': 0, 'subNotes': []},
      ];
      
      // Filter by blue color
      var filtered = db.toDoList.where((task) => task['color'] == 'blue').toList();
      
      // Sort by completion (incomplete first)
      filtered.sort((a, b) {
        bool completedA = a['completed'] ?? false;
        bool completedB = b['completed'] ?? false;
        return completedA == completedB ? 0 : (completedA ? 1 : -1);
      });
      
      expect(filtered.length, 3);
      expect(filtered[0]['name'], 'Task 2');
      expect(filtered[0]['completed'], false);
      expect(filtered[1]['completed'], true);
      expect(filtered[2]['completed'], true);
    });
  });

  group('Date Sorting Tests', () {
    test('sort by created date - most recent first', () {
      final db = ToDoDatabase();
      final now = DateTime.now();
      db.toDoList = [
        {
          'name': 'Old Task',
          'completed': false,
          'color': 'yellow',
          'groupIndex': 0,
          'subNotes': [],
          'createdAt': now.subtract(const Duration(days: 5)).toIso8601String(),
        },
        {
          'name': 'Recent Task',
          'completed': false,
          'color': 'blue',
          'groupIndex': 0,
          'subNotes': [],
          'createdAt': now.subtract(const Duration(days: 1)).toIso8601String(),
        },
        {
          'name': 'Oldest Task',
          'completed': false,
          'color': 'red',
          'groupIndex': 0,
          'subNotes': [],
          'createdAt': now.subtract(const Duration(days: 10)).toIso8601String(),
        },
      ];
      
      // Sort by created date (most recent first)
      db.toDoList.sort((a, b) {
        DateTime? dateA = date_utils.parseDateTimeSafe(a['createdAt']);
        DateTime? dateB = date_utils.parseDateTimeSafe(b['createdAt']);
        if (dateA == null && dateB == null) return 0;
        if (dateA == null) return 1;
        if (dateB == null) return -1;
        return dateB.compareTo(dateA);
      });
      
      expect(db.toDoList[0]['name'], 'Recent Task');
      expect(db.toDoList[1]['name'], 'Old Task');
      expect(db.toDoList[2]['name'], 'Oldest Task');
    });

    test('sort by due date - earliest first', () {
      final db = ToDoDatabase();
      final now = DateTime.now();
      db.toDoList = [
        {
          'name': 'Task Due Next Week',
          'completed': false,
          'color': 'yellow',
          'groupIndex': 0,
          'subNotes': [],
          'dueDate': now.add(const Duration(days: 7)).toIso8601String(),
        },
        {
          'name': 'Task Due Tomorrow',
          'completed': false,
          'color': 'blue',
          'groupIndex': 0,
          'subNotes': [],
          'dueDate': now.add(const Duration(days: 1)).toIso8601String(),
        },
        {
          'name': 'Task Due in 3 Days',
          'completed': false,
          'color': 'red',
          'groupIndex': 0,
          'subNotes': [],
          'dueDate': now.add(const Duration(days: 3)).toIso8601String(),
        },
      ];
      
      // Sort by due date (earliest first)
      db.toDoList.sort((a, b) {
        DateTime? dateA = date_utils.parseDateTimeSafe(a['dueDate']);
        DateTime? dateB = date_utils.parseDateTimeSafe(b['dueDate']);
        if (dateA == null && dateB == null) return 0;
        if (dateA == null) return 1;
        if (dateB == null) return -1;
        return dateA.compareTo(dateB);
      });
      
      expect(db.toDoList[0]['name'], 'Task Due Tomorrow');
      expect(db.toDoList[1]['name'], 'Task Due in 3 Days');
      expect(db.toDoList[2]['name'], 'Task Due Next Week');
    });

    test('sort by due date - tasks without due dates go last', () {
      final db = ToDoDatabase();
      final now = DateTime.now();
      db.toDoList = [
        {
          'name': 'No Due Date',
          'completed': false,
          'color': 'yellow',
          'groupIndex': 0,
          'subNotes': [],
          'dueDate': null,
        },
        {
          'name': 'Task Due Tomorrow',
          'completed': false,
          'color': 'blue',
          'groupIndex': 0,
          'subNotes': [],
          'dueDate': now.add(const Duration(days: 1)).toIso8601String(),
        },
        {
          'name': 'Another No Due Date',
          'completed': false,
          'color': 'red',
          'groupIndex': 0,
          'subNotes': [],
          'dueDate': null,
        },
      ];
      
      // Sort by due date (earliest first, nulls last)
      db.toDoList.sort((a, b) {
        DateTime? dateA = date_utils.parseDateTimeSafe(a['dueDate']);
        DateTime? dateB = date_utils.parseDateTimeSafe(b['dueDate']);
        if (dateA == null && dateB == null) return 0;
        if (dateA == null) return 1;
        if (dateB == null) return -1;
        return dateA.compareTo(dateB);
      });
      
      expect(db.toDoList[0]['name'], 'Task Due Tomorrow');
      expect(db.toDoList[1]['dueDate'], null);
      expect(db.toDoList[2]['dueDate'], null);
    });
  });
}
