import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import '../services/draft_service.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;

  const TaskFormScreen({Key? key, this.task}) : super(key: key);

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  TextEditingController? _titleController;
  TextEditingController? _descriptionController;
  DateTime? _selectedDueDate;
  TaskStatus _selectedStatus = TaskStatus.todo;
  String? _selectedBlockedBy;
  bool _isSaving = false;
  bool _isInitializing = true;
  final _draftService = DraftService();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _draftService.init();
    _initializeForm();
    if (mounted) {
      setState(() {
        _isInitializing = false;
      });
    }
  }

  void _initializeForm() {
    if (widget.task != null) {
      // Editing existing task
      _titleController = TextEditingController(text: widget.task!.title);
      _descriptionController =
          TextEditingController(text: widget.task!.description);
      _selectedDueDate = widget.task!.dueDate;
      _selectedStatus = widget.task!.status;
      _selectedBlockedBy = widget.task!.blockedBy;
    } else {
      // Creating new task - load draft if exists
      final draft = _draftService.getDraft();
      _titleController = TextEditingController(text: draft?['title'] ?? '');
      _descriptionController =
          TextEditingController(text: draft?['description'] ?? '');
      _selectedDueDate =
          _parseDate(draft?['dueDate']) ?? DateTime.now().add(const Duration(days: 1));
      _selectedStatus = _parseStatus(draft?['status']) ?? TaskStatus.todo;
      _selectedBlockedBy = draft?['blockedBy'];
    }

    // Save draft on every change
    _titleController?.addListener(_saveDraft);
    _descriptionController?.addListener(_saveDraft);
  }

  TaskStatus? _parseStatus(String? status) {
    if (status == null || status.isEmpty) return null;
    for (final value in TaskStatus.values) {
      if (value.name == status) {
        return value;
      }
    }
    return null;
  }

  DateTime? _parseDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    try {
      return DateTime.parse(dateStr);
    } catch (e) {
      return null;
    }
  }

  void _saveDraft() {
    _draftService.saveDraft({
      'title': _titleController?.text ?? '',
      'description': _descriptionController?.text ?? '',
      'dueDate': _selectedDueDate?.toIso8601String(),
      'status': _selectedStatus.name,
      'blockedBy': _selectedBlockedBy,
    });
  }

  @override
  void dispose() {
    _titleController?.dispose();
    _descriptionController?.dispose();
    // Don't clear draft on dispose
    super.dispose();
  }

  Future<void> _selectDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDueDate = picked;
        _saveDraft();
      });
    }
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    // Simulate 2-second delay
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final taskService = context.read<TaskService>();

    if (widget.task == null) {
      // Create new task
      final newTask = Task(
        id: '', // Will be set by service
        title: _titleController!.text,
        description: _descriptionController!.text,
        dueDate: _selectedDueDate!,
        status: _selectedStatus,
        blockedBy: _selectedBlockedBy,
      );
      await taskService.addTask(newTask);
      await _draftService.clearDraft();
    } else {
      // Update existing task
      final updatedTask = widget.task!.copyWith(
        title: _titleController!.text,
        description: _descriptionController!.text,
        dueDate: _selectedDueDate!,
        status: _selectedStatus,
        blockedBy: _selectedBlockedBy,
      );
      await taskService.updateTask(updatedTask);
    }

    setState(() => _isSaving = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.task == null ? 'Task created!' : 'Task updated!',
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing || _titleController == null || _descriptionController == null || _selectedDueDate == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final taskService = context.watch<TaskService>();
    final isTaskBlocked = widget.task != null
        ? taskService.isTaskBlocked(widget.task!.id)
        : false;
    final blockingTaskTitle = widget.task != null
        ? taskService.getBlockingTaskTitle(widget.task!.id)
        : null;

    final availableBlockers = taskService.allTasks
        .where((task) => task.id != widget.task?.id)
        .toList();
    final isBlockedByValueValid = _selectedBlockedBy == null ||
        availableBlockers.any((task) => task.id == _selectedBlockedBy);
    final blockedByValue = isBlockedByValueValid ? _selectedBlockedBy : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'New Task' : 'Edit Task'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Blocked warning
              if (isTaskBlocked)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.red.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.lock,
                        color: Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'This task is blocked',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Complete the blocking task "$blockingTaskTitle" first',
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              // Title field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter task title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description field
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter task description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.description),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Due date picker
              GestureDetector(
                onTap: _selectDueDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.blue),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Due Date',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            DateFormat('MMM dd, yyyy').format(_selectedDueDate!),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Status dropdown
              DropdownButtonFormField<TaskStatus>(
                initialValue: _selectedStatus,
                decoration: InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.flag),
                ),
                items: TaskStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(
                      status == TaskStatus.todo
                          ? 'To-Do'
                          : status == TaskStatus.inProgress
                              ? 'In Progress'
                              : 'Done',
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedStatus = value;
                      _saveDraft();
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String?>(
                initialValue: blockedByValue,
                decoration: InputDecoration(
                  labelText: 'Blocked By (Optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.link),
                ),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('None'),
                  ),
                  ...availableBlockers.map(
                    (task) => DropdownMenuItem<String?>(
                      value: task.id,
                      child: Text(task.title),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedBlockedBy = value;
                    _saveDraft();
                  });
                },
              ),
              const SizedBox(height: 24),

              // Save button with loading indicator
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    disabledBackgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          isTaskBlocked
                              ? 'Save changes (currently blocked)'
                              : (widget.task == null ? 'Create Task' : 'Update Task'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
