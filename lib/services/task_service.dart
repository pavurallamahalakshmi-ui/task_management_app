import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';

class TaskService extends ChangeNotifier {
  static const String boxName = 'tasks';
  late Box<Task> _taskBox;
  List<Task> _tasks = [];
  String _searchQuery = '';
  TaskStatus? _filterStatus;

  List<Task> get tasks {
    List<Task> filtered = _tasks;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((task) =>
              task.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Apply status filter
    if (_filterStatus != null) {
      filtered = filtered.where((task) => task.status == _filterStatus).toList();
    }

    return filtered;
  }

  String get searchQuery => _searchQuery;
  TaskStatus? get filterStatus => _filterStatus;
  int get totalTaskCount => _tasks.length;
  List<Task> get allTasks => List.unmodifiable(_tasks);

  Future<void> init() async {
    try {
      // Initialize Hive
      await Hive.initFlutter();
      
      // Register adapters with duplicate check
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(TaskAdapter());
      }
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(TaskStatusAdapter());
      }
      
      // Open box with error recovery
      try {
        _taskBox = await Hive.openBox<Task>(boxName);
      } catch (e) {
        debugPrint('Error opening Hive box: $e');
        debugPrint('Attempting database recovery...');
        try {
          await Hive.deleteBoxFromDisk(boxName);
          _taskBox = await Hive.openBox<Task>(boxName);
          debugPrint('Database recovered');
        } catch (recoveryError) {
          debugPrint('Recovery failed: $recoveryError');
          rethrow;
        }
      }
      
      // Load tasks
      _loadTasks();
      debugPrint('TaskService ready with ${_tasks.length} tasks');
    } catch (e) {
      debugPrint('TaskService init error: $e');
      rethrow;
    }
  }

  void _loadTasks() {
    try {
      _tasks = _taskBox.values.toList();
      _tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
      debugPrint('Loaded ${_tasks.length} tasks from Hive');
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading tasks: $e');
      _tasks = [];
      notifyListeners();
    }
  }

  Future<void> addTask(Task task) async {
    final taskWithId = task.copyWith(id: const Uuid().v4());
    await _taskBox.put(taskWithId.id, taskWithId);
    _loadTasks();
  }

  Future<void> updateTask(Task task) async {
    final updatedTask = task.copyWith(updatedAt: DateTime.now());
    await _taskBox.put(task.id, updatedTask);
    _loadTasks();
  }

  Future<void> deleteTask(String taskId) async {
    await _taskBox.delete(taskId);
    _loadTasks();
  }

  Future<void> updateTaskStatus(String taskId, TaskStatus newStatus) async {
    final task = _taskBox.get(taskId);
    if (task != null) {
      await updateTask(task.copyWith(status: newStatus));
    }
  }

  bool isTaskBlocked(String taskId) {
    final task = _taskBox.get(taskId);
    if (task == null || task.blockedBy == null) return false;

    final blockingTask = _taskBox.get(task.blockedBy!);
    if (blockingTask == null) return false;

    return blockingTask.status != TaskStatus.done;
  }

  bool isTaskBlockedByDependency(Task task) {
    if (task.blockedBy == null) return false;
    final blockingTask = _taskBox.get(task.blockedBy!);
    if (blockingTask == null) return false;
    return blockingTask.status != TaskStatus.done;
  }

  String? getBlockingTaskTitle(String taskId) {
    final task = _taskBox.get(taskId);
    if (task?.blockedBy == null) return null;

    final blockingTask = _taskBox.get(task!.blockedBy!);
    return blockingTask?.title;
  }

  String? getBlockingTaskTitleById(String? blockingTaskId) {
    if (blockingTaskId == null) return null;
    return _taskBox.get(blockingTaskId)?.title;
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilterStatus(TaskStatus? status) {
    _filterStatus = status;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _filterStatus = null;
    notifyListeners();
  }

  Task? getTaskById(String id) => _taskBox.get(id);

  Future<void> clearAll() async {
    await _taskBox.clear();
    _loadTasks();
  }
}
