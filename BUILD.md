# Build & Run Instructions

## First-Time Setup

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Generate Hive Adapters
Since we're using Hive with code generation, you need to run the build_runner:

```bash
flutter pub run build_runner build
```

Or use this command if the above doesn't work:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This generates the `task.g.dart` file needed for Hive serialization.

### 3. Run the App
```bash
flutter run
```

---

## Ongoing Development

### After Making Changes to Task Model
If you modify the `Task` class in `lib/models/task.dart`, regenerate adapters:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Watch Mode for Auto-Rebuilds
For continuous development, use watch mode:

```bash
flutter pub run build_runner watch
```

This automatically regenerates files when you save changes.

---

## Common Issues & Solutions

### Issue: "part 'task.g.dart'; could not be found"
**Solution**: Run build runner:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: Hive error about typeId
**Solution**: Make sure task.dart has the correct decorators:
```dart
@HiveType(typeId: 0)  // Correct
class Task extends HiveObject {
  @HiveField(0)       // Sequential field IDs
  late String id;
  // ...
}
```

### Issue: "Typeids are not allowed to be same"
**Solution**: Each model needs a unique typeId. Currently:
- Task = typeId: 0

If you add more models, use 1, 2, 3, etc.

### Issue: Port already in use
**Solution**: Stop other Flutter processes or use a different device:
```bash
flutter run -d <device_id>
flutter devices  # to see available devices
```

---

## Building for Release

### Android APK
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

---

## Project Dependencies

Check installed packages:
```bash
flutter pub deps
```

Update all packages:
```bash
flutter pub upgrade
```

---

## Useful Commands

```bash
# Check Flutter version
flutter --version

# Check device connectivity
flutter devices

# Run with specific device
flutter run -d <device_name>

# Run in profile mode (better performance analysis)
flutter run --profile

# Build runner options
flutter pub run build_runner watch      # Watch mode
flutter pub run build_runner build      # Build once
flutter pub run build_runner clean      # Clean generated files

# Analyze code quality
flutter analyze

# Format code
dart format lib/
```

---

## File Structure After Generation

After running build_runner, you'll get:

```
lib/models/
├── task.dart       # Original
└── task.g.dart     # Generated (Don't edit this!)
```

The `.g.dart` file is auto-generated and contains Hive adapters needed for serialization.

---

## Database Management

### Clear Local Data
Add this to TaskService class:
```dart
Future<void> clearAll() async {
  await _taskBox.clear();
  _loadTasks();
}
```

Then call from UI when needed.

### Access Database Files (Debug)
Hive stores data in:
- **Android**: `getApplicationDocumentsDirectory()`
- **iOS**: `NSDocumentDirectory`
- **Windows**: `appData\Local\`

---

## Tips & Tricks

1. **Fast Rebuild**: Use `r` (reload) instead of restarting
2. **Profile Mode**: Run `flutter run --profile` to check performance
3. **Debug Logs**: Add `print()` statements (avoid `print` in production)
4. **Hot Reload**: Changes in UI files reload instantly (not Hive code)
5. **Clean Build**: Use `flutter clean` if experiencing strange errors

---

## Environment Setup Checklist

- [ ] Flutter SDK installed
- [ ] Dart SDK installed (comes with Flutter)
- [ ] Android Studio or VS Code installed
- [ ] Emulator/Device connected
- [ ] Ran `flutter pub get`
- [ ] Ran `flutter pub run build_runner build`
- [ ] App runs with `flutter run`

---

That's it! Happy coding! 🚀
