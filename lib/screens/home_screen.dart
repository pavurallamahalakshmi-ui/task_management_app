import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../models/task.dart';
import '../services/task_service.dart';
import '../widgets/task_list_item.dart';
import '../widgets/status_filter.dart';
import 'task_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  Timer? _searchDebounce;
  String _liveSearchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Management'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Consumer<TaskService>(
        builder: (context, taskService, child) {
          return Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _liveSearchQuery = value;
                    });

                    _searchDebounce?.cancel();
                    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
                      if (!mounted) return;
                      taskService.setSearchQuery(value);
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search tasks...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _liveSearchQuery = '';
                              });
                              taskService.setSearchQuery('');
                            },
                          )
                        : null,
                  ),
                ),
              ),

              // Status filter
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: StatusFilter(
                  selectedStatus: taskService.filterStatus,
                  onStatusChanged: (status) {
                    taskService.setFilterStatus(status);
                  },
                  onClear: () {
                    taskService.clearFilters();
                    _searchController.clear();
                    setState(() {
                      _liveSearchQuery = '';
                    });
                  },
                ),
              ),

              // Task list
              Expanded(
                child: Builder(
                  builder: (context) {
                    final tasks = taskService.allTasks.where((task) {
                      final matchesTitle = _liveSearchQuery.trim().isEmpty ||
                          task.title
                              .toLowerCase()
                              .contains(_liveSearchQuery.toLowerCase());
                      final matchesStatus = taskService.filterStatus == null ||
                          task.status == taskService.filterStatus;
                      return matchesTitle && matchesStatus;
                    }).toList();

                    if (tasks.isEmpty) {
                      final hasAnyTask = taskService.totalTaskCount > 0;
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.inbox,
                              size: 64,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              hasAnyTask
                                  ? 'No tasks match your search/filter.'
                                  : 'No tasks yet. Create one!',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        final isBlocked = taskService.isTaskBlockedByDependency(task);
                        final blockingTaskTitle =
                            taskService.getBlockingTaskTitleById(task.blockedBy);

                        return TaskListItem(
                          task: task,
                          searchQuery: _liveSearchQuery,
                          isBlocked: isBlocked,
                          blockingTaskTitle: blockingTaskTitle,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TaskFormScreen(task: task),
                              ),
                            );
                          },
                          onStatusChanged: (newStatus) {
                            taskService.updateTaskStatus(task.id, newStatus);
                          },
                          onDelete: () {
                            _showDeleteDialog(context, task, taskService);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TaskFormScreen(task: null),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Task task, TaskService taskService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              taskService.deleteTask(task.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Task deleted')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
