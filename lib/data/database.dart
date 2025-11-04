import 'package:hive_flutter/hive_flutter.dart';

class ToDoDatabase {
  List toDoList = [];
  List groups = [];
  List trash = [];

  final _myBox = Hive.box('mybox');

  void createInitialData() {
    // Create default group with some tasks
    groups = [
      {
        "name": "Personal",
        "icon": "person",
        "color": "blue",
        "expanded": true,
      },
      {
        "name": "Work",
        "icon": "work",
        "color": "orange",
        "expanded": true,
      },
    ];
    
    toDoList = [
      {
        "name": "Make Tutorial",
        "completed": false,
        "color": "yellow",
        "groupIndex": 0,
        "subNotes": [],
        "dueDate": null,
        "dueTime": null,
        "recurrence": null,
        "createdAt": DateTime.now().toIso8601String(),
      },
      {
        "name": "Do Exercise",
        "completed": false,
        "color": "yellow",
        "groupIndex": 0,
        "subNotes": [],
        "dueDate": null,
        "dueTime": null,
        "recurrence": null,
        "createdAt": DateTime.now().toIso8601String(),
      },
    ];
  }

  void loadData() {
    // Load groups
    var loadedGroups = _myBox.get("GROUPS");
    if (loadedGroups != null) {
      groups = List.from(loadedGroups);
    } else {
      groups = [];
    }
    
    // Load trash
    var loadedTrash = _myBox.get("TRASH");
    if (loadedTrash != null) {
      trash = List.from(loadedTrash);
    } else {
      trash = [];
    }
    
    // Load todos
    var loadedTodos = _myBox.get("TODOLIST");
    if (loadedTodos != null) {
      toDoList = List.from(loadedTodos);
      
      // Migrate old list format [name, completed, color] to new map format
      for (int i = 0; i < toDoList.length; i++) {
        if (toDoList[i] is List) {
          // Old format migration
          var oldItem = toDoList[i] as List;
          toDoList[i] = {
            "name": oldItem[0],
            "completed": oldItem.length > 1 ? oldItem[1] : false,
            "color": oldItem.length > 2 ? oldItem[2] : "yellow",
            "groupIndex": 0, // Assign to first group or -1 if no groups
            "subNotes": [],
            "dueDate": null,
            "dueTime": null,
            "recurrence": null,
            "createdAt": DateTime.now().toIso8601String(),
          };
        } else if (toDoList[i] is Map) {
          // Ensure all fields exist
          var item = Map<String, dynamic>.from(toDoList[i]);
          if (!item.containsKey("subNotes")) {
            item["subNotes"] = [];
          }
          if (!item.containsKey("groupIndex")) {
            item["groupIndex"] = groups.isNotEmpty ? 0 : -1;
          }
          if (!item.containsKey("dueDate")) {
            item["dueDate"] = null;
          }
          if (!item.containsKey("dueTime")) {
            item["dueTime"] = null;
          }
          if (!item.containsKey("recurrence")) {
            item["recurrence"] = null;
          }
          if (!item.containsKey("createdAt")) {
            item["createdAt"] = DateTime.now().toIso8601String();
          }
          
          // Migrate sub-notes to include color field
          if (item.containsKey("subNotes") && item["subNotes"] is List) {
            List subNotes = item["subNotes"];
            for (int j = 0; j < subNotes.length; j++) {
              if (subNotes[j] is Map) {
                var subNote = Map<String, dynamic>.from(subNotes[j]);
                if (!subNote.containsKey("color")) {
                  subNote["color"] = "yellow";  // Default color for sub-notes
                }
                subNotes[j] = subNote;
              }
            }
          }
          
          toDoList[i] = item;
        }
      }
    } else {
      toDoList = [];
    }
  }

  void updateDatabase() {
    _myBox.put("TODOLIST", toDoList);
    _myBox.put("GROUPS", groups);
    _myBox.put("TRASH", trash);
  }
}
