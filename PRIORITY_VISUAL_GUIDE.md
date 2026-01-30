# Priority Feature Visual Guide

## Overview
This guide provides a visual description of the new Priority Levels feature implemented in the to-do app.

## Priority Levels

### Visual Indicators

```
┌─────────────────────────────────────────────────┐
│  HIGH PRIORITY                                  │
│  ┌─────────────────────────────────────────┐   │
│  │  ⬆️  High  │ Red border & background     │   │
│  │  Icon: priority_high (up arrow)         │   │
│  │  Color: Colors.red (#F44336)            │   │
│  └─────────────────────────────────────────┘   │
└─────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────┐
│  MEDIUM PRIORITY (Default)                      │
│  ┌─────────────────────────────────────────┐   │
│  │  ➖  Medium  │ Orange border & background│   │
│  │  Icon: remove (horizontal line)         │   │
│  │  Color: Colors.orange (#FF9800)         │   │
│  └─────────────────────────────────────────┘   │
└─────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────┐
│  LOW PRIORITY                                   │
│  ┌─────────────────────────────────────────┐   │
│  │  ⬇️  Low  │ Green border & background    │   │
│  │  Icon: arrow_downward (down arrow)      │   │
│  │  Color: Colors.green (#4CAF50)          │   │
│  └─────────────────────────────────────────┘   │
└─────────────────────────────────────────────────┘
```

## Task Tile with Priority Badge

```
┌───────────────────────────────────────────────────────────┐
│ Task Tile (Example: High Priority)                        │
│ ┌───────────────────────────────────────────────────────┐ │
│ │ ☑️ [Task Name Here]              [⬆️ High]          │ │
│ │                                                       │ │
│ │ 📅 12/15/2024, 2:00 PM                               │ │
│ │                                    [3] 🔔 ⋯         │ │
│ └───────────────────────────────────────────────────────┘ │
│                                                            │
│ Legend:                                                    │
│ - ☑️ Checkbox for completion                              │
│ - [Task Name Here] The task description                   │
│ - [⬆️ High] Priority badge (color-coded)                  │
│ - 📅 Date/time indicator (if set)                         │
│ - [3] Sub-notes count badge                               │
│ - 🔔 Add sub-note button                                   │
│ - ⋯ More options menu                                     │
└───────────────────────────────────────────────────────────┘
```

## User Flows

### 1. Creating a Task with Priority

```
Step 1: Tap + Button
┌─────────────────────┐
│   [+] Add Task      │
└─────────────────────┘
           ↓
Step 2: Fill Task Details
┌─────────────────────────────────────┐
│  Add New Task                       │
│  ┌───────────────────────────────┐  │
│  │ Enter task name               │  │
│  └───────────────────────────────┘  │
│                                     │
│  Choose Color:                      │
│  🟡 🔴 🔵 🟢 🟠 🟣 🌸 🐢 🔷 🟨      │
│                                     │
│  Priority:                          │
│  ┌───────────────────────────────┐  │
│  │ ⬆️ High  ➖ Medium*  ⬇️ Low   │  │
│  └───────────────────────────────┘  │
│  (* = selected)                     │
│                                     │
│  Due Date & Time: [Optional]        │
│  Recurrence: [Optional]             │
│                                     │
│  [Save] [Cancel]                    │
└─────────────────────────────────────┘
```

### 2. Changing Task Priority

```
Step 1: Swipe Left on Task
┌──────────────────────────────────────┐
│ ← Swipe                              │
│ Task Name [⬇️ Low]  [⚙️ Options] [🗑️] │
└──────────────────────────────────────┘
           ↓
Step 2: Tap Options
┌─────────────────────────┐
│  Task Options           │
│  ┌───────────────────┐  │
│  │ 📅 Edit Date      │  │
│  │ 🎨 Change Color   │  │
│  │ 🚩 Change Priority│◄─ Select this
│  │ 📁 Move to Group  │  │
│  └───────────────────┘  │
└─────────────────────────┘
           ↓
Step 3: Select New Priority
┌─────────────────────────┐
│  Choose Priority        │
│  ┌───────────────────┐  │
│  │ ⬆️ High          ✓│◄─ Tap to select
│  │ ➖ Medium          │  │
│  │ ⬇️ Low   (current) │  │
│  └───────────────────┘  │
└─────────────────────────┘
```

### 3. Sorting by Priority

```
Step 1: Tap Filter Icon
┌────────────────────────┐
│ To Do    🔍  [🎚️]     │ ← Tap filter icon
└────────────────────────┘
           ↓
Step 2: Select Sort Option
┌─────────────────────────────────┐
│  Filter & Sort                  │
│  ┌───────────────────────────┐  │
│  │ Status: All | ✓ | ✗       │  │
│  │ Color: All | 🟡 | 🔴...   │  │
│  │                            │  │
│  │ Sort by:                   │  │
│  │ ○ None                     │  │
│  │ ○ Name                     │  │
│  │ ○ Status                   │  │
│  │ ○ Created Date             │  │
│  │ ○ Due Date                 │  │
│  │ ● Priority                 │◄─ Select this
│  └───────────────────────────┘  │
│  [Reset] [Close]                │
└─────────────────────────────────┘
           ↓
Result: Tasks Sorted
┌─────────────────────────────┐
│ ☐ Important Meeting [⬆️ High]│
│ ☐ Client Call [⬆️ High]      │
│ ☐ Email Team [➖ Medium]     │
│ ☐ Review Docs [➖ Medium]    │
│ ☐ Clean Desk [⬇️ Low]        │
└─────────────────────────────┘
```

## Color Palette

### Priority Colors with Opacity Variations

**High Priority (Red)**
- Border: `Colors.red` (#F44336)
- Background: `Colors.red.withOpacity(0.2)` (20% opacity)
- Icon: `Colors.red`

**Medium Priority (Orange)**
- Border: `Colors.orange` (#FF9800)
- Background: `Colors.orange.withOpacity(0.2)` (20% opacity)
- Icon: `Colors.orange`

**Low Priority (Green)**
- Border: `Colors.green` (#4CAF50)
- Background: `Colors.green.withOpacity(0.2)` (20% opacity)
- Icon: `Colors.green`

## Integration Points

### Where Priority Appears:

1. **Task Creation Dialog**
   - ChoiceChip selector with icons
   - Visual feedback on selection
   - Default: Medium

2. **Task Tile**
   - Compact badge next to task name
   - Icon + Label format
   - Color-coded border and background

3. **Task Options Menu**
   - "Change Priority" option
   - Accessible via swipe actions

4. **Priority Picker Dialog**
   - Full-screen list of priorities
   - Current selection indicated with checkmark
   - Tap to change

5. **Filter/Sort Dialog**
   - "Priority" option in sort section
   - Sorts high to low (0 → 1 → 2)

6. **Database**
   - Stored as string: "high", "medium", "low"
   - Default: "medium"
   - Preserved in recurring tasks

## Implementation Details

### Badge Layout
```
┌──────────────────────────────────┐
│ Row(                             │
│   mainAxisSize: MainAxisSize.min │
│   children: [                    │
│     Icon (14px)                  │
│     SizedBox (4px)               │
│     Text (11px, bold)            │
│   ]                              │
│ )                                │
└──────────────────────────────────┘

Container:
- Padding: 6px horizontal, 2px vertical
- Border: 1.5px solid (priority color)
- BorderRadius: 8px
- Background: priority color @ 20% opacity
```

### Sort Order
```dart
getPrioritySortOrder(priority):
  "high"   → 0 (first)
  "medium" → 1 (middle)
  "low"    → 2 (last)
```

## Benefits

### User Experience
✅ Quick visual identification of important tasks
✅ Intuitive color associations (red=urgent, green=relaxed)
✅ Consistent with Material Design patterns
✅ No learning curve required

### Functionality
✅ Sort tasks by importance
✅ Focus on high-priority items first
✅ Organize workflow effectively
✅ Track task urgency visually

### Technical
✅ Clean, reusable code
✅ Type-safe implementation
✅ Backward compatible
✅ Easy to extend

## Future Enhancements

Potential improvements mentioned in roadmap:
- Auto-priority suggestions based on due dates
- Priority-based task recommendations
- Priority statistics in analytics dashboard
- Priority-based notifications (urgent tasks alert sooner)
- Smart priority adjustment based on completion patterns
