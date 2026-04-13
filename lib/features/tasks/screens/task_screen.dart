import 'package:flutter/material.dart';
import 'package:last_launcher/features/app_drawer/widgets/app_search_field.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/features/tasks/task.dart';
import 'package:last_launcher/features/tasks/task_state.dart';
import 'package:last_launcher/shared/widgets/app_label.dart';
import 'package:last_launcher/shared/widgets/fade_overflow.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({
    required this.taskState,
    required this.settingsState,
    required this.isVisible,
    required this.isReordering,
    super.key,
  });

  final TaskState taskState;
  final SettingsState settingsState;
  final bool isVisible;
  final ValueNotifier<bool> isReordering;

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _scrollController = ScrollController();
  bool get _autoKeyboard => widget.settingsState.autoKeyboard;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(TaskScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      if (_autoKeyboard) {
        _focusNode.requestFocus();
      }
    } else if (!widget.isVisible && oldWidget.isVisible) {
      _focusNode.unfocus();
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.offset > 0 && _focusNode.hasFocus) {
      _focusNode.unfocus();
    } else if (_scrollController.offset <= 0 &&
        !_focusNode.hasFocus &&
        _autoKeyboard) {
      _focusNode.requestFocus();
    }
  }

  void _onOverscroll(OverscrollNotification notification) {
    if (notification.overscroll > 0 && _focusNode.hasFocus) {
      _focusNode.unfocus();
    } else if (notification.overscroll < 0 &&
        !_focusNode.hasFocus &&
        _autoKeyboard) {
      _focusNode.requestFocus();
    }
  }

  void _onSubmit() {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    final tasks = widget.taskState.tasks;
    final match = tasks.where(
      (t) => t.title.toLowerCase() == query.toLowerCase(),
    );

    if (match.isNotEmpty) {
      widget.taskState.toggleTask(match.first.id);
    } else {
      widget.taskState.addTask(query);
    }

    _controller.clear();
    _focusNode.requestFocus();
  }

  void _editTask(BuildContext context, Task task) async {
    final result = await showDialog<_EditResult>(
      context: context,
      builder: (context) => _EditTaskDialog(title: task.title),
    );
    if (result == null) return;
    if (result.delete) {
      widget.taskState.removeTask(task.id);
    } else if (result.title.isNotEmpty && result.title != task.title) {
      widget.taskState.renameTask(task.id, result.title);
    }
  }

  List<Task> _filteredTasks(List<Task> tasks) {
    final filter = _controller.text;
    if (filter.isEmpty) return tasks;
    final lower = filter.toLowerCase();
    return tasks.where((t) => t.title.toLowerCase().contains(lower)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.1 -
                  MediaQuery.paddingOf(context).top +
                  4,
            ),
            AppSearchField(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: (_) {},
              onSubmit: _onSubmit,
            ),
            Expanded(
              child: ListenableBuilder(
                listenable: widget.taskState,
                builder: (context, _) {
                  final tasks = _filteredTasks(widget.taskState.tasks);
                  return NotificationListener<OverscrollNotification>(
                    onNotification: (notification) {
                      _onOverscroll(notification);
                      return false;
                    },
                    child: FadeOverflow(
                      child: ReorderableListView.builder(
                        scrollController: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(top: 32, bottom: 80),
                        buildDefaultDragHandles: false,
                        proxyDecorator: (child, _, _) =>
                            Material(color: Colors.transparent, child: child),
                        onReorderStart: (_) =>
                            widget.isReordering.value = true,
                        onReorderEnd: (_) =>
                            widget.isReordering.value = false,
                        onReorder: widget.taskState.reorder,
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return InkWell(
                            key: ValueKey(task.id),
                            onTap: () =>
                                widget.taskState.toggleTask(task.id),
                            onLongPress: () =>
                                _editTask(context, task),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: AppLabel.verticalPadding,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      task.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontSize: AppLabel.fontSize,
                                            decoration: task.done
                                                ? TextDecoration.lineThrough
                                                : null,
                                            decorationThickness:
                                                task.done ? 2 : null,
                                          ),
                                    ),
                                  ),
                                  ReorderableDragStartListener(
                                    index: index,
                                    child: const Opacity(
                                      opacity: 0,
                                      child: Icon(Icons.drag_handle),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditResult {
  const _EditResult.rename(this.title) : delete = false;
  const _EditResult.delete()
      : title = '',
        delete = true;

  final String title;
  final bool delete;
}

class _EditTaskDialog extends StatefulWidget {
  const _EditTaskDialog({required this.title});

  final String title;

  @override
  State<_EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<_EditTaskDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.title);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    Navigator.pop(context, _EditResult.rename(_controller.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit task'),
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
          onPressed: () =>
              Navigator.pop(context, const _EditResult.delete()),
          child: const Text('Delete'),
        ),
        TextButton(onPressed: _submit, child: const Text('Save')),
      ],
    );
  }
}
