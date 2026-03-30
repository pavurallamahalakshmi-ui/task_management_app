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

---

## AI Usage Report

### Helpful prompts used
- “Implement Flutter task form draft persistence so unsaved input survives navigation/back/minimize.”
- “Add blocked-by dependency logic and visually grey out blocked tasks.”
- “Add debounced search + title highlight in Flutter list UI.”

### One AI mistake and fix
- **Issue:** Generated null-safe code that used an unsupported helper (`firstOrNull`) for this project setup.
- **Fix:** Replaced with a manual enum parsing loop to avoid unsupported extension usage and keep compatibility.

---

## Notes

- Data is stored locally using Hive and persists across app restarts.
- The app is focused on clean architecture and assignment-complete functionality for Track B.