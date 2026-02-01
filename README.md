# to_do_app

A modern Flutter to-do list application with groups, sub-notes, and beautiful UI.

## Features

### ✨ Organization
- **Group Tasks** - Organize tasks into customizable groups
- **8 Group Icons** - Choose from person, work, home, shopping, fitness, book, star, and favorite
- **10 Colors** - Beautiful color options for both groups and tasks
- **Expand/Collapse** - Show or hide groups and sub-notes
- **Advanced Tagging System** - Add custom tags to tasks (e.g., #urgent, #waiting, #home, #office)
- **Smart Categories** - Auto-categorize tasks based on keywords with 8 predefined categories
- **Tag-based Filtering** - Filter tasks by tags with frequently used tags quick-access
- **Category-based Filtering** - Filter tasks by category for better organization

### 📝 Task Management
- Create and manage to-do tasks
- Mark tasks as complete/incomplete
- Delete tasks with swipe gesture
- **Priority Levels** - Assign High, Medium, or Low priority to tasks with color-coded badges
- **Auto-Priority Suggestions** - Smart priority suggestions based on due dates and keywords
- **Priority Recommendations** - Visual banner showing high-priority tasks that need attention
- **Date & Time** - Set due dates and times for tasks (similar to Google Tasks)
- **Overdue indicators** - Visual highlighting for overdue tasks
- **Recurrence** - Set tasks to repeat daily, weekly, or monthly (automatically creates new task when completed)
- **Sub-notes** - Add one level of sub-tasks to any task
- Assign tasks to groups
- **Customize task colors** - Choose from 10 different colors for each task
- **Move tasks between groups** - Easily reorganize tasks across different groups
- **Move sub-notes between tasks** - Transfer sub-notes from one task to another
- **Customize sub-note colors** - Each sub-note can have its own color
- **Drag and drop** - Reorder tasks when no groups exist
- **Filter & Sort** - Filter by status, tags, or categories; sort by name, completion status, priority, or due date
- **Multiple Tags per Task** - Flexible categorization with multiple tags
- **Tag Suggestions** - Auto-suggest tags based on task names using keyword matching

### 🎨 Modern UI
- Material Design 3 principles
- Gradient backgrounds with shadows
- Rounded corners and smooth animations
- Clean and intuitive interface
- Empty state guidance

### 🔒 Security
- Biometric authentication (fingerprint/Face ID)
- Optional app lock for privacy
- User authentication system

### 💾 Data Persistence
- Local storage using Hive
- Automatic data migration
- User authentication

## How to Use

### Managing Groups
**Create a Group:**
1. Tap the orange folder button at the bottom right
2. Enter a group name
3. Select an icon that represents the group
4. Choose a color
5. Tap "Save"

**Edit a Group:**
1. Swipe left on the group
2. Tap the edit icon (✏️)
3. Modify name, icon, or color
4. Tap "Save"

**Delete a Group:**
1. Swipe left on the group
2. Tap the delete icon (🗑️)
3. Confirm deletion (all tasks in the group will be deleted)

**Expand/Collapse:**
- Tap on any group tile to show or hide its tasks

### Managing Tasks
**Create a Task:**
1. Tap the blue plus (+) button at the bottom right
2. Select which group to add the task to (if multiple groups exist)
3. Enter your task name
4. Select a color from the color picker
5. (Optional) Select a priority level: High (red), Medium (orange), or Low (green)
   - The app may auto-suggest a priority based on keywords in the task name or due date
6. (Optional) Set a due date by tapping "Select Date"
7. (Optional) If date is set, you can also set a time by tapping "Select Time"
8. (Optional) Set a recurrence pattern: None, Daily, Weekly, or Monthly
9. (Optional) **Add Tags**: Select from common tags or tap "+ Custom" to create your own
   - The app will auto-suggest tags based on keywords in your task name
10. (Optional) **Select a Category**: Choose from predefined categories like Shopping, Work, Health, etc.
   - The app will auto-suggest a category based on keywords in your task name
11. Tap "Save"

**Add Sub-notes:**
1. Click the + button on any task
2. Enter the sub-note text
3. Tap "Add"
4. Sub-notes appear indented under the parent task

**Complete Sub-notes:**
- Click the checkbox on any sub-note to mark it complete
- Completed sub-notes show with strikethrough text

**Expand/Collapse Sub-notes:**
- If a task has sub-notes, a badge shows the count
- Tap the expand/collapse icon to show or hide sub-notes

**Edit Task Options:**
1. Swipe left on any task to reveal action buttons
2. Tap the "Options" button (⋮) to see:
   - Edit Date & Time
   - Change Color
   - Change Priority
   - Move to Group (if multiple groups exist)
3. Or tap the "Delete" button to remove the task

**Set or Edit Due Date, Time & Recurrence:**
1. Use the "Options" menu and select "Edit Date & Time", or
2. Tap directly on the displayed date/time indicator on the task
3. Select a due date from the calendar picker
4. (Optional) Select a time from the time picker
5. (Optional) Set recurrence: None, Daily, Weekly, or Monthly
6. Tap "Save"
7. To clear date/time, tap the X button next to the date or time field

**View Due Dates and Recurrence:**
- Tasks with due dates show a calendar icon and date below the task name
- Tasks due today are labeled "Today"
- **Overdue tasks** are highlighted with a red background and border
- Recurring tasks show a repeat icon (🔁) with the recurrence pattern
- When you complete a recurring task, a new instance is automatically created with the next due date

**Reorder Tasks:**
- When no groups exist, long-press and drag tasks to reorder them
- Sub-notes show a drag handle icon (☰) indicating they can be reordered

**Delete a Task:**
1. Swipe left on the task
2. Tap the delete icon (🗑️)

**Delete a Sub-note:**
1. Expand the task to show sub-notes
2. Click the X button on the sub-note you want to remove

**Move Task Between Groups:**
1. Swipe left on any task (when multiple groups exist)
2. Tap the move icon (📁)
3. Select the target group from the dialog
4. Task moves to the selected group

**Move Sub-note to Another Task:**
1. Expand the task to show sub-notes
2. Click the move up icon (↑) on the sub-note
3. Select the target task from the dialog
4. Sub-note moves to the selected task

**Change Sub-note Color:**
1. Expand the task to show sub-notes
2. Click the palette icon (🎨) on any sub-note
3. Select a new color from the color picker
4. The sub-note color updates immediately

**Filter & Sort Tasks:**
1. Tap the filter icon in the app bar (top right)
2. Select status filter: All, Completed, or Incomplete
3. **Select tag filter**: Choose from frequently used tags to show only tasks with that tag
4. **Select category filter**: Choose from predefined categories to show only tasks in that category
5. Select sort option: None, Name (alphabetical), Status (incomplete first), Priority (high to low), or Due Date
6. Active filters show a red indicator on the filter icon
7. Tap "Reset" to clear all filters and sorting

**Priority Recommendations:**
- A priority alert banner appears at the top when you have high-priority tasks
- The banner shows how many high-priority tasks need attention
- Tap on high-priority tasks to focus on what's important first

**Using Tags:**
- Tags appear as colored chips below the task name
- Each task can have multiple tags for flexible organization
- Use tags to create custom workflows (e.g., #urgent, #waiting, #followup)
- Filter by tag to see all tasks in a specific context

**Using Categories:**
- Categories help organize tasks by type (Shopping, Work, Health, etc.)
- Categories show with an icon and name badge on the task
- Auto-categorization suggests categories based on task keywords
- Filter by category to focus on specific areas of your life

### Security Settings

**Enable Biometric Authentication:**
1. Go to Settings from the home page
2. Navigate to the "Security" section
3. Toggle on "Biometric Authentication"
4. Authenticate with fingerprint or Face ID to confirm
5. Once enabled, the app will require biometric authentication on startup

**Disable Biometric Authentication:**
1. Go to Settings
2. Navigate to the "Security" section
3. Toggle off "Biometric Authentication"
4. The app will no longer require biometric authentication

**Note:** Biometric authentication requires device support for fingerprint or Face ID. If your device doesn't support biometrics, the option will be disabled with a message "Not available on this device".

### Trash Management

**View Deleted Tasks:**
1. Go to Settings
2. Tap on "Trash"
3. View all deleted tasks with deletion timestamps

**Restore a Task:**
1. In the Trash page, find the task you want to restore
2. Tap the restore icon (↻) next to the task
3. The task will be moved back to your active task list

**Permanently Delete a Task:**
1. In the Trash page, find the task you want to delete permanently
2. Tap the delete forever icon (🗑️) next to the task
3. Confirm the deletion
4. The task will be permanently removed

**Empty Trash:**
1. In the Trash page, tap the "Empty Trash" icon in the app bar
2. Confirm the action
3. All tasks in trash will be permanently deleted

### Available Colors
- Yellow
- Red
- Blue
- Green
- Orange
- Purple
- Pink
- Teal
- Cyan
- Amber

### Available Priority Levels
- **High** (🔴) - Urgent and important tasks that need immediate attention
- **Medium** (🟠) - Regular tasks with moderate importance
- **Low** (🟢) - Tasks that can be done when time permits

### Available Group Icons
- Person (👤) - Personal tasks
- Work (💼) - Professional tasks
- Home (🏠) - Household tasks
- Shopping (🛒) - Shopping lists
- Fitness (💪) - Exercise and health
- Book (📚) - Learning and reading
- Star (⭐) - Important items
- Favorite (❤️) - Priority tasks

## Roadmap: Future Feature Enhancements 🚀

This section outlines potential features to transform this into a comprehensive, enterprise-grade to-do application:

### ✅ Recently Implemented Features
The following features from the roadmap have been implemented:

**Enhanced Priority Features** ✅
- Priority-based task recommendations ("Focus on high-priority tasks first") - Implemented as priority alert banner
- Auto-priority suggestions based on due dates and keywords - Fully functional
- Priority statistics and analytics - Available through filter system

**Advanced Tagging System** ✅
- Add custom tags beyond groups (e.g., #urgent, #waiting, #home, #office) - Implemented with 15 common tags + custom tags
- Multiple tags per task for flexible categorization - Fully supported
- Tag-based filtering and searching - Available in filter dialog
- Tag statistics and analytics - View frequently used tags
- Suggested tags based on task names using simple keyword matching - Auto-suggestion implemented

**Smart Categories** ✅
- Auto-categorization based on keywords (e.g., "buy" → Shopping) - 8 predefined categories with keyword matching
- Frequently used categories quick-access - Shown in filter dialog
- Category templates with predefined task lists - Templates defined for each category

📚 **Documentation**: See [ENHANCED_FEATURES.md](ENHANCED_FEATURES.md) and [ENHANCED_FEATURES_GUIDE.md](ENHANCED_FEATURES_GUIDE.md) for detailed information on using these features.

### 🎯 Priority & Organization
**~~Enhanced Priority Features~~** ✅ IMPLEMENTED (see above)

**~~Advanced Tagging System~~** ✅ IMPLEMENTED (see above)

**~~Smart Categories~~** ✅ IMPLEMENTED (see above)

### 📝 Enhanced Task Management
**Rich Task Details**
- Extended notes with Markdown support
- File attachments (images, PDFs, documents)
- URL/link attachments with preview
- Voice notes recording and playback
- Task dependencies (task A must be completed before task B)
- Estimated time vs actual time tracking

**Advanced Subtasks**
- Multi-level nested subtasks (unlimited depth)
- Subtask progress tracking with percentage completion
- Independent subtask deadlines
- Subtask templates for recurring task structures

**Task Templates**
- Create reusable task templates for common workflows
- Quick task creation from templates
- Template library with common task types
- Share templates with other users

### ⏰ Smart Scheduling & Reminders
**Intelligent Notifications**
- Push notifications for due dates and times
- Smart reminders based on location (e.g., remind when near grocery store)
- Customizable reminder intervals (15 min, 1 hour, 1 day before)
- Snooze functionality for reminders
- Recurring reminder patterns

**Time Management**
- Time blocking and calendar integration
- Pomodoro timer integration for task focus sessions
- Daily/weekly time budgets per category
- Time spent analytics and reports
- Focus mode to hide distractions

**Smart Scheduling**
- AI-powered task time suggestions based on completion history
- Optimal task ordering based on deadlines and priorities
- Calendar view with drag-and-drop rescheduling
- Time conflict detection

### 🔍 Search & Discovery
**Advanced Search**
- Full-text search across all tasks, notes, and subtasks
- Search by date range, color, group, priority
- Search filters and saved search queries
- Search history and suggestions
- Voice search capability

**Quick Actions**
- Keyboard shortcuts for power users
- Gesture-based quick actions
- Customizable action buttons
- Batch operations (select multiple tasks)

### 📊 Analytics & Insights
**Productivity Dashboard**
- Task completion rates over time (daily, weekly, monthly)
- Category-wise time distribution charts
- Productivity trends and patterns
- Streak tracking for daily task completion
- Task completion forecasting

**Reports & Statistics**
- Overdue tasks report
- Most productive days/times analysis
- Task completion velocity
- Export reports as PDF/CSV
- Visual charts and graphs (pie, bar, line charts)

**Habit Tracking**
- Track daily habits and routines
- Habit streaks and consistency scoring
- Habit reminders
- Habit progress visualization

### 🌐 Collaboration & Sharing
**Team Features**
- Share tasks and groups with other users
- Assign tasks to team members
- Collaborative task lists
- Real-time updates and synchronization
- Comments and discussions on tasks
- Activity feed showing team actions

**Social Features**
- Share completed tasks to social media
- Task achievement badges and milestones
- Public task templates gallery
- Community-contributed templates

### ☁️ Cloud & Sync
**Cross-Device Synchronization**
- Real-time cloud sync via Firebase or similar
- Conflict resolution for offline changes
- Sync status indicators
- Selective sync (choose what to sync)
- Backup and restore functionality

**Multi-Platform Support**
- Web app version
- Desktop apps (Windows, macOS, Linux)
- Browser extensions
- Smartwatch companion apps

### 🎨 Customization & Themes
**Visual Customization**
- Full dark mode support
- Multiple theme presets (Light, Dark, AMOLED Black, Solarized)
- Custom theme creation with color picker
- Per-group color schemes
- Custom fonts and text sizes
- Animated backgrounds and effects

**Layout Options**
- List view, grid view, board view (Kanban)
- Compact and comfortable display densities
- Customizable card layouts
- Dashboard widgets customization

### 🔐 Advanced Security
**Enhanced Privacy**
- Pattern lock (already mentioned as "Coming Soon")
- PIN code protection
- App-specific passwords
- Task encryption for sensitive data
- Private tasks (hidden from quick view)
- Auto-lock after inactivity

**Data Control**
- Export all data (JSON, CSV, PDF)
- Import from other to-do apps
- Selective data deletion
- GDPR compliance tools

### 🛠️ Integrations
**Calendar Integration**
- Google Calendar sync
- Apple Calendar sync
- Outlook Calendar sync
- Two-way synchronization

**Third-Party Integrations**
- Email integration (create tasks from emails)
- Slack/Teams integration
- Google Drive/Dropbox for attachments
- IFTTT/Zapier automation
- Voice assistants (Google Assistant, Siri, Alexa)

**API & Automation**
- RESTful API for custom integrations
- Webhooks for task events
- Automation rules (if-this-then-that)

### 📱 Mobile Enhancements
**Home Screen Widgets**
- Today's tasks widget
- Upcoming tasks widget
- Quick add task widget
- Task counter widget
- Progress tracker widget

**Platform Features**
- Share extension (add tasks from other apps)
- Siri Shortcuts support
- 3D Touch quick actions
- Notification actions (complete/snooze without opening app)

### ♿ Accessibility
**Enhanced Accessibility**
- Screen reader optimization
- Voice commands for all actions
- High contrast themes
- Adjustable font sizes
- Keyboard navigation support
- Reduced motion options

### 🌍 Localization
**Multi-Language Support**
- Support for 20+ languages
- RTL (Right-to-Left) language support
- Regional date/time formats
- Currency support for shopping tasks

### 💡 Smart Features
**AI-Powered Assistance**
- Smart task suggestions based on patterns
- Auto-complete task names
- Duplicate task detection
- Natural language task input ("Remind me to buy milk tomorrow at 5 PM")
- Task priority suggestions based on deadlines

**Gamification**
- Achievement system with unlockable badges
- Points and levels for task completion
- Daily/weekly challenges
- Leaderboards (for team mode)
- Reward animations

### 📈 Business/Professional Features
**Project Management**
- Gantt chart view for task timelines
- Milestone tracking
- Resource allocation
- Budget tracking for tasks/projects
- Client/customer association

**Meeting Integration**
- Convert meeting notes to tasks
- Pre-meeting task reminders
- Post-meeting action items tracking

### 🔄 Advanced Workflows
**Automation**
- Automatic task creation rules
- Scheduled task generation
- Workflow templates
- Custom automation scripts

**Task Relationships**
- Parent-child task hierarchies
- Task linking and references
- Blocking task dependencies
- Related tasks suggestions

## Implementation Priority

Based on user value and development effort, here's a suggested implementation order:

**Phase 1: Enhanced Core Features (3-4 months)**
1. Advanced search functionality
2. Push notifications and smart reminders
3. Multi-level subtasks
4. Enhanced notes with rich text
5. Advanced tagging system

**Phase 2: Productivity & Analytics (2-3 months)**
6. Analytics dashboard
7. Time tracking
8. Habit tracking
9. Task templates
10. Dark mode

**Phase 3: Collaboration & Cloud (4-5 months)**
11. Cloud synchronization
12. Sharing and collaboration
13. Multi-platform support
14. Calendar integration

**Phase 4: Advanced Features (3-4 months)**
15. AI-powered suggestions
16. Advanced integrations
17. Gamification
18. API access

**Phase 5: Polish & Scale (2-3 months)**
19. Localization
20. Accessibility improvements
21. Performance optimization
22. Enterprise features

## Technical Debt & Improvements

While adding features, consider addressing these technical improvements:
- Migrate from Hive to a more robust database (SQLite/Drift) for better query capabilities
- Implement proper state management (Provider, Riverpod, or Bloc)
- Add comprehensive unit and integration tests
- Implement proper error handling and logging
- Create a proper data model layer with type safety
- Add CI/CD pipeline for automated testing and deployment
- Implement analytics tracking for feature usage

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
