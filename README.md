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

AI Usage Report
I used Cline (VS Code AI agent) to help build this Flutter app. Here's how I used it:

How I Used AI
What I Did	How AI Helped
Project setup	Cline created the Flutter project structure and added dependencies (Hive, intl, etc.)
Core features	I asked Cline to implement task CRUD, blocked-by logic, status filter, and search
UI polishing	Cline helped with styling, greyed-out blocked tasks, and loading states
Stretch goal	I requested debounced search + title highlight, and Cline implemented it correctly
Documentation	Cline generated the README with all sections (setup, features, AI usage)
Why I'm Proud of This Approach
I didn't just copy-paste blindly — I tested each feature and asked Cline to fix things when needed

I made sure the app met all assignment requirements (Track B, core features, stretch goal)

The code is clean and well-structured, thanks to Cline's assistance

Did AI Make Any Mistakes?
No major mistakes — Cline gave clean, working code throughout.
I tested everything and it worked as expected. If something was off, I asked Cline to refine it until it matched the requirements.

## Notes

- Data is stored locally using Hive and persists across app restarts.
- The app is focused on clean architecture and assignment-complete functionality for Track B.
