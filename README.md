# Flodo AI Take-Home Assignment – Task Management App

This project is a **Flutter Task Management App** built for the Flodo AI take-home assignment.

## ✅ Selected Track

- **Track B: The Mobile Specialist**
- Tech stack: **Flutter + Dart + Hive (local persistence)**

## ✅ Selected Stretch Goal

- **Debounced Autocomplete Search**
  - Search text updates UI results instantly.
  - Debounced search logic is applied with a 300ms timer.
  - Matching task title text is highlighted in task cards.

---

## Implemented Features

### Core Data Model (required fields)
Each task includes:
- `title` (String)
- `description` (String)
- `dueDate` (DateTime)
- `status` (To-Do / In Progress / Done)
- `blockedBy` (optional task id of one blocker)

### Screens/UI
- **Main List View**
  - Lists all tasks
  - Search by title
  - Filter by status
  - Blocked tasks are visually distinct (greyed card + blocker label)
- **Task Creation/Edit Screen**
  - Input for all required fields
  - Optional “Blocked By” dropdown of existing tasks

### Required Functionality
- ✅ CRUD (Create, Read, Update, Delete)
- ✅ Draft persistence for new-task form (survives back/minimize)
- ✅ Search by title
- ✅ Status filter
- ✅ Simulated 2-second delay on create/update
- ✅ Loading state shown during save
- ✅ Save button disabled while saving (prevents double-tap)

### Blocking Behavior
- If Task B is blocked by Task A, Task B is shown as blocked until Task A status is **Done**.

---

## Project Structure

```text
lib/
├── main.dart
├── models/
│   ├── task.dart
│   └── task.g.dart
├── screens/
│   ├── home_screen.dart
│   └── task_form_screen.dart
├── services/
│   ├── task_service.dart
│   └── draft_service.dart
└── widgets/
    ├── status_filter.dart
    └── task_list_item.dart
```

---

## Setup Instructions

1. Install Flutter SDK and verify:
   ```bash
   flutter --version
   ```

2. Get dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

4. (Optional) Static analysis:
   ```bash
   flutter analyze
   ```

## Commit History

Commits were kept logical and atomic, with each commit focused on one clear change. Example commit sequence:

1. `feat: initialize Flutter app structure and base task model`
2. `feat: add Hive local persistence setup`
3. `feat: implement task create/edit form with validation`
4. `feat: implement task list view with status display`
5. `feat: add update and delete actions for tasks`
6. `feat: implement blocked-by dependency behavior in UI`
7. `feat: add draft persistence for unsaved form input`
8. `feat: add simulated save delay and loading button state`
9. `feat: implement debounced autocomplete search with title highlight`
10. `docs: update README with setup, track, stretch goal, and AI usage`

---

## AI Usage Report

I used Cline (VS Code AI agent) mainly as a coding assistant while building this app.

### How I used AI
- Asked for implementation help in Flutter for CRUD flow, blocked-by logic, and draft persistence.
- Asked for UI improvements like blocked-task visual state and loading/disable behavior during save.
- Asked for stretch-goal implementation support: debounced search and title-match highlight.
- Used AI help for structuring and polishing README content.

### Prompts used (summary)
- “Implement Flutter task form draft persistence so unsaved input survives back navigation/minimize.”
- “Add blocked-by dependency logic and visually indicate blocked tasks.”
- “Add 300ms debounced search with matching text highlight in task titles.”
- “Provide a natural 60–90 second demo script and clean commit-history format.”

### Validation and ownership
- I tested the app manually for full CRUD, blocked behavior, draft restore, and search behavior.
- I reviewed and adjusted AI output before finalizing the submission.

## Notes

- Data is stored locally using Hive and persists across app restarts.
- The app is focused on clean architecture and assignment-complete functionality for Track B.
