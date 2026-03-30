# Quick Start Guide

## ⚡ Get Started in 3 Steps

### Step 1: Install Dependencies
```bash
flutter pub get
```

### Step 2: Run the App
```bash
flutter run
```

Choose your device/emulator when prompted.

### Step 3: Start Creating Tasks!
- Tap the **+** button to create a new task
- Enter title, description, and select a due date
- Your form will auto-save as you type
- Click **Create Task** to save (2-second delay simulated)

---

## 📱 Quick Feature Overview

### On Home Screen
- **Search bar**: Type to filter tasks by title
- **Status filter**: Click To-Do, In Progress, or Done to filter
- **Task list**: Shows all tasks sorted by due date
- **Red "OVERDUE"**: Indicates tasks past due date
- **Edit**: Tap any task to edit it
- **Delete**: Long-press or tap the delete icon

### On Task Form
- **Auto-save draft**: Your input is saved automatically
- **Draft persistence**: Reload the form and your draft is still there!
- **Loading indicator**: You'll see a spinner during the 2-second save
- **Save button**: Disabled while saving

---

## 🔧 Project Structure

```
task_management_app/
│
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/
│   │   └── task.dart             # Task model with enums
│   ├── services/
│   │   ├── task_service.dart     # State & CRUD operations
│   │   └── draft_service.dart    # Form draft storage
│   ├── screens/
│   │   ├── home_screen.dart      # Main task list
│   │   └── task_form_screen.dart # Create/edit screen
│   └── widgets/
│       ├── task_list_item.dart   # Task card UI
│       └── status_filter.dart    # Filter chips UI
│
├── pubspec.yaml                  # Dependencies
├── analysis_options.yaml         # Lint rules
├── README.md                     # Full documentation
├── .gitignore                    # Git ignore rules
└── QUICK_START.md               # This file!
```

---

## 📦 What's Included

| Feature | Implementation |
|---------|-----------------|
| Local Storage | Hive (simple & fast) |
| State Management | Provider (simple & powerful) |
| Task Model | Complete with status enum |
| CRUD Operations | Create, Read, Update, Delete |
| Search | Real-time title search |
| Filtering | By status (3 options) |
| Draft Saving | Auto-save form input |
| Loading State | 2-second simulated delay |
| Date Picking | Flutter date picker |
| Overdue Detection | Visual indicators |
| Responsive UI | Simple Material design |

---

## 🎯 App Workflow

```
Launch App
    ↓
Home Screen
    ├─→ View Tasks (sorted by due date)
    ├─→ Search by title
    ├─→ Filter by status
    ├─→ Edit task (tap)
    ├─→ Delete task
    └─→ Create task (+)
         ↓
      Form Screen
         ├─→ Auto-saves draft
         ├─→ Pick due date
         ├─→ Set status
         └─→ Save (2-sec load)
             ↓
          Success! ✨
```

---

## 🚀 Next Steps

1. **Install**: `flutter pub get`
2. **Run**: `flutter run`
3. **Create tasks**: Try creating a few tasks
4. **Test features**: Search, filter, edit, delete
5. **Try form draft**: Enter text, close, reopen form

---

## 💾 Data Persistence

- All tasks saved in **Hive** local database
- Form drafts saved separately
- Changes persist across app restarts
- No internet required
- ~MB storage for typical use

---

## 🐛 Troubleshooting

**App won't run?**
```bash
flutter clean
flutter pub get
flutter run
```

**See Hive errors?**
Normal! First run creates database files.

**Want to clear all data?**
- Delete the app
- Or add a "Clear All" button (see code)

---

## 📝 Code Tips

- All UI in `lib/screens/` - easy to customize
- `TaskService` handles all logic
- Models in `lib/models/` are simple & reusable
- Widgets in `lib/widgets/` are modular

---

Happy task managing! 🎉
