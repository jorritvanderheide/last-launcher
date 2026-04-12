import 'package:flutter/material.dart';
import 'package:last_launcher/features/tasks/task_state.dart';
import 'package:last_launcher/shared/widgets/app_label.dart';
import 'package:last_launcher/shared/widgets/fade_overflow.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({required this.taskState, super.key});

  final TaskState taskState;

  void _addTask(BuildContext context) async {
    final title = await _showAddTaskDialog(context);
    if (title != null && title.isNotEmpty) {
      taskState.addTask(title);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListenableBuilder(
                listenable: taskState,
                builder: (context, _) {
                  final tasks = taskState.tasks;
                  if (tasks.isEmpty) {
                    return Center(
                      child: Text(
                        'No tasks',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha(100),
                        ),
                      ),
                    );
                  }
                  return FadeOverflow(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 32, bottom: 32),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return AppLabel(
                          key: ValueKey(task.id),
                          label: task.title,
                          onTap: () => taskState.removeTask(task.id),
                          onLongPress: () {},
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => _addTask(context),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 48,
                    top: AppLabel.verticalPadding,
                    bottom: AppLabel.verticalPadding + 8,
                  ),
                  child: Text(
                    '＋',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: AppLabel.fontSize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<String?> _showAddTaskDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (context) => const _AddTaskDialog(),
  );
}

class _AddTaskDialog extends StatefulWidget {
  const _AddTaskDialog();

  @override
  State<_AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<_AddTaskDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    Navigator.pop(context, _controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add task'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          isDense: true,
        ),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(onPressed: _submit, child: const Text('Add')),
      ],
    );
  }
}
