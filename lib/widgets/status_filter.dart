import 'package:flutter/material.dart';
import '../models/task.dart';

class StatusFilter extends StatelessWidget {
  final TaskStatus? selectedStatus;
  final Function(TaskStatus?) onStatusChanged;
  final VoidCallback onClear;

  const StatusFilter({
    Key? key,
    required this.selectedStatus,
    required this.onStatusChanged,
    required this.onClear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(
            'Filter by Status',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        Row(
          children: [
            _buildFilterChip(
              label: 'To-Do',
              status: TaskStatus.todo,
              isSelected: selectedStatus == TaskStatus.todo,
              onTap: () {
                onStatusChanged(
                  selectedStatus == TaskStatus.todo ? null : TaskStatus.todo,
                );
              },
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              label: 'In Progress',
              status: TaskStatus.inProgress,
              isSelected: selectedStatus == TaskStatus.inProgress,
              onTap: () {
                onStatusChanged(
                  selectedStatus == TaskStatus.inProgress
                      ? null
                      : TaskStatus.inProgress,
                );
              },
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              label: 'Done',
              status: TaskStatus.done,
              isSelected: selectedStatus == TaskStatus.done,
              onTap: () {
                onStatusChanged(
                  selectedStatus == TaskStatus.done ? null : TaskStatus.done,
                );
              },
            ),
            const SizedBox(width: 8),
            if (selectedStatus != null)
              GestureDetector(
                onTap: onClear,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: const Text(
                    'Clear',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required TaskStatus status,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    Color getStatusColor() {
      switch (status) {
        case TaskStatus.todo:
          return Colors.orange;
        case TaskStatus.inProgress:
          return Colors.blue;
        case TaskStatus.done:
          return Colors.green;
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? getStatusColor().withValues(alpha: 0.2)
              : Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? getStatusColor() : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? getStatusColor() : Colors.grey,
          ),
        ),
      ),
    );
  }
}
