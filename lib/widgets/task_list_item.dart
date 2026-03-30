import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';

class TaskListItem extends StatelessWidget {
  final Task task;
  final String searchQuery;
  final bool isBlocked;
  final String? blockingTaskTitle;
  final VoidCallback onTap;
  final Function(TaskStatus) onStatusChanged;
  final VoidCallback onDelete;

  const TaskListItem({
    Key? key,
    required this.task,
    required this.searchQuery,
    required this.isBlocked,
    this.blockingTaskTitle,
    required this.onTap,
    required this.onStatusChanged,
    required this.onDelete,
  }) : super(key: key);

  InlineSpan _buildHighlightedTitle() {
    if (searchQuery.trim().isEmpty) {
      return TextSpan(text: task.title);
    }

    final lowerTitle = task.title.toLowerCase();
    final lowerQuery = searchQuery.toLowerCase();
    final matchIndex = lowerTitle.indexOf(lowerQuery);

    if (matchIndex < 0) {
      return TextSpan(text: task.title);
    }

    return TextSpan(
      children: [
        TextSpan(text: task.title.substring(0, matchIndex)),
        TextSpan(
          text: task.title.substring(matchIndex, matchIndex + searchQuery.length),
          style: const TextStyle(
            backgroundColor: Colors.yellow,
            fontWeight: FontWeight.w700,
          ),
        ),
        TextSpan(text: task.title.substring(matchIndex + searchQuery.length)),
      ],
    );
  }

  Color _getStatusColor() {
    switch (task.status) {
      case TaskStatus.todo:
        return Colors.orange;
      case TaskStatus.inProgress:
        return Colors.blue;
      case TaskStatus.done:
        return Colors.green;
    }
  }

  Color _getStatusBackgroundColor() {
    switch (task.status) {
      case TaskStatus.todo:
        return Colors.orange.withValues(alpha: 0.1);
      case TaskStatus.inProgress:
        return Colors.blue.withValues(alpha: 0.1);
      case TaskStatus.done:
        return Colors.green.withValues(alpha: 0.1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: isBlocked ? Colors.grey.shade100 : null,
      elevation: isBlocked ? 0 : 1,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and status
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isBlocked ? Colors.grey.shade600 : Colors.black,
                            ),
                            children: [_buildHighlightedTitle()],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          task.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: isBlocked ? Colors.grey.shade500 : Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (isBlocked && blockingTaskTitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Blocked by: $blockingTaskTitle',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusBackgroundColor(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      task.statusString,
                      style: TextStyle(
                        color: _getStatusColor(),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Due date and actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: task.isOverdue ? Colors.red : Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('MMM dd').format(task.dueDate),
                        style: TextStyle(
                          fontSize: 12,
                          color: task.isOverdue ? Colors.red : Colors.grey,
                          fontWeight: task.isOverdue ? FontWeight.bold : null,
                        ),
                      ),
                      if (task.isOverdue)
                        const Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Text(
                            'OVERDUE',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PopupMenuButton<TaskStatus>(
                        onSelected: onStatusChanged,
                        itemBuilder: (BuildContext context) =>
                            TaskStatus.values.map((status) {
                          return PopupMenuItem(
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
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.more_vert),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: onDelete,
                        iconSize: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
