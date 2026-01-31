# Enhanced Features Usage Guide

## Quick Start Examples

### Example 1: Creating a Task with Auto-Suggestions

**Task:** "Urgent: Buy groceries for dinner party"

1. Create the task
2. The app will automatically suggest:
   - **Priority**: High (due to "urgent" keyword)
   - **Tags**: urgent, shopping
   - **Category**: Shopping (due to "buy" keyword)
3. Accept the suggestions or modify as needed
4. Add additional tags like `personal` if desired

**Result**: A well-organized, high-priority shopping task.

---

### Example 2: Using Categories for Weekly Planning

**Scenario:** Planning your week

1. Create tasks with category keywords:
   - "Pay electricity bill" → Auto-categorized as Finance
   - "Doctor checkup" → Auto-categorized as Health
   - "Project presentation" → Auto-categorized as Work
   - "Buy birthday gift" → Auto-categorized as Shopping

2. Use category filtering:
   - Monday: Focus on Finance tasks
   - Tuesday: Focus on Health tasks
   - Wednesday-Thursday: Focus on Work tasks
   - Friday: Handle Shopping tasks

**Result**: Organized weekly schedule by category.

---

### Example 3: Tag-Based Context Switching

**Scenario:** Managing different work contexts

1. Tag tasks by context:
   - "Review contract" → Tags: `work`, `review`, `important`
   - "Call client about proposal" → Tags: `work`, `call`, `urgent`
   - "Send project updates" → Tags: `work`, `email`
   - "Meeting with team" → Tags: `work`, `meeting`

2. Filter by tag based on your current context:
   - At desk with phone: Filter by `call`
   - Checking emails: Filter by `email`
   - Before meetings: Filter by `meeting`

**Result**: Efficient task batching by context.

---

### Example 4: Priority-Based Daily Focus

**Scenario:** Starting your workday

1. Open the app and see the priority alert banner:
   - "Focus on 5 high-priority tasks first!"

2. Review high-priority tasks:
   - Tasks marked urgent
   - Tasks with keywords like "asap", "critical"
   - Tasks due within 2 days

3. Complete high-priority tasks first

4. Move to medium and low priority tasks

**Result**: Most important work completed first.

---

### Example 5: Using Multiple Tags for Complex Projects

**Task:** "Urgent meeting with doctor to review test results and discuss treatment plan"

**Tags to add:**
- `urgent` (time-sensitive)
- `meeting` (requires scheduling)
- `health` (category context)
- `important` (significance)
- `followup` (action type)

**Benefits:**
- Filter by `urgent` to see all time-sensitive tasks
- Filter by `meeting` when planning your calendar
- Filter by `health` for health-related tasks
- Filter by `followup` to see tasks requiring follow-up action

**Result**: Multi-faceted organization for complex tasks.

---

## Common Workflows

### Workflow 1: Morning Task Review

1. Open app, check priority alert banner
2. Review high-priority tasks
3. Filter by today's context (e.g., `office` or `home`)
4. Add any new urgent tasks
5. Set priorities for new tasks using auto-suggestions

### Workflow 2: Weekly Planning

1. Create tasks for the week
2. Let app auto-categorize based on keywords
3. Review and adjust categories as needed
4. Use category filtering to plan each day
5. Add due dates and let app suggest priorities

### Workflow 3: Task Batching

1. Filter by specific tag (e.g., `email`)
2. Complete all tasks with that tag
3. Switch context by changing tag filter
4. Repeat for different contexts

### Workflow 4: Priority Management

1. Create new task with due date
2. Let app suggest priority based on due date
3. Override if needed based on importance
4. Check priority alert banner regularly
5. Update task priorities as due dates approach

---

## Pro Tips

### Tags
- **Use consistent tag names**: Stick to lowercase for consistency
- **Don't over-tag**: 2-4 tags per task is usually sufficient
- **Create custom tags** for specific projects or workflows
- **Review frequent tags** in the filter dialog to see your patterns

### Categories
- **Let auto-categorization help**: The app is smart about keywords
- **One category per task**: Categories are for high-level organization
- **Use templates**: Category templates help you remember common tasks
- **Combine with tags**: Use categories for "what" and tags for "how/when/where"

### Priorities
- **Trust auto-suggestions**: The app considers both keywords and due dates
- **Review regularly**: Priorities should change as due dates approach
- **Use the banner**: The priority alert banner helps you focus
- **Balance your load**: Don't make everything high priority

### Filtering
- **Combine filters**: Use status + tag + category for precise filtering
- **Save mental energy**: Use filters instead of scrolling through long lists
- **Quick reset**: The reset button clears all filters instantly
- **Active indicator**: Red dot on filter icon shows when filters are active

---

## Keyboard Shortcuts & Quick Actions

### Adding Tags Quickly
1. Start typing task name
2. Include keywords that trigger auto-suggestions
3. Accept suggested tags or add custom ones
4. Common patterns become faster with practice

### Category Selection
1. Include category keywords in task name
2. App auto-selects category
3. Override only if needed
4. Saves time on task creation

---

## Advanced Usage

### Custom Tag Creation
Create tags for:
- **Projects**: `project-alpha`, `project-beta`
- **Clients**: `client-acme`, `client-xyz`
- **Locations**: `downtown`, `home-office`
- **Time blocks**: `morning`, `evening`
- **Energy levels**: `high-energy`, `low-energy`

### Tag Combinations
Examples of powerful tag combinations:
- `urgent` + `waiting` = Blocked urgent tasks
- `work` + `call` + `followup` = Work calls needing follow-up
- `personal` + `home` + `weekend` = Personal home tasks for weekends

### Priority Strategies
- **2-Day Rule**: Tasks due in 2 days or less → High priority
- **Keyword Escalation**: Any task with "urgent" → High priority
- **Weekly Review**: Review and adjust priorities every Monday
- **Focus Time**: Dedicate first 2 hours to high-priority tasks

---

## Troubleshooting

### Tags Not Showing
- Ensure tags array is not empty
- Check that tags are strings
- Verify migration completed successfully

### Category Not Auto-Selecting
- Check if task name contains category keywords
- Keywords must be in task name, not description
- See ENHANCED_FEATURES.md for complete keyword list

### Priority Alert Not Showing
- Requires at least one incomplete high-priority task
- Banner only shows when task list is not empty
- Check that priority is set to "high"

---

## Migration Notes

All existing tasks are automatically migrated with:
- Empty tags array
- No category (null)
- Existing priority preserved (or medium if not set)

After migration:
1. Review existing tasks
2. Add relevant tags
3. Assign categories where appropriate
4. Adjust priorities if needed
