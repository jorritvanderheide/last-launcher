import 'package:flutter/material.dart';
import 'package:last_launcher/features/app_drawer/widgets/app_search_field.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/features/tasks/task.dart';
import 'package:last_launcher/features/tasks/task_state.dart';
import 'package:last_launcher/shared/widgets/app_label.dart';
import 'package:last_launcher/shared/widgets/fade_overflow.dart';
import 'package:last_launcher/shared/widgets/rename_dialog.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({
    required this.taskState,
    required this.settingsState,
    required this.isVisible,
    required this.onReorderStart,
    required this.onReorderEnd,
    super.key,
  });

  final TaskState taskState;
  final SettingsState settingsState;
  final bool isVisible;
  final VoidCallback onReorderStart;
  final VoidCallback onReorderEnd;

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _scrollController = ScrollController();
  double _cumulativeOverscroll = 0;
  bool get _autoKeyboard =>
      widget.settingsState.searchOnly || widget.settingsState.autoKeyboard;

  @override
  void initState() {
    super.initState();
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
    if (_scrollController.offset > 20 && _focusNode.hasFocus) {
      _focusNode.unfocus();
    } else if (_scrollController.offset <= 0 &&
        !_focusNode.hasFocus &&
        _autoKeyboard) {
      _focusNode.requestFocus();
    }
  }

  void _onOverscroll(OverscrollNotification notification) {
    _cumulativeOverscroll += notification.overscroll;
    if (_cumulativeOverscroll > 20 && _focusNode.hasFocus) {
      _focusNode.unfocus();
      _cumulativeOverscroll = 0;
    } else if (_cumulativeOverscroll < -20 &&
        !_focusNode.hasFocus &&
        _autoKeyboard) {
      _focusNode.requestFocus();
      _cumulativeOverscroll = 0;
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
      _completeTask(match.first);
    } else {
      widget.taskState.addTask(query);
    }

    _controller.clear();
    _focusNode.requestFocus();
  }

  void _completeTask(Task task) {
    if (!task.done && widget.settingsState.removeOnComplete) {
      widget.taskState.removeTask(task.id);
    } else {
      widget.taskState.toggleTask(task.id);
    }
  }

  void _showTaskOptions(BuildContext context, Task task) {
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  task.title,
                  style: Theme.of(sheetContext).textTheme.titleMedium,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Rename'),
                onTap: () async {
                  Navigator.pop(sheetContext);
                  final result = await showRenameDialog(
                    context: context,
                    currentLabel: task.title,
                    originalLabel: task.title,
                  );
                  if (result != null &&
                      result.isNotEmpty &&
                      result != task.title) {
                    widget.taskState.renameTask(task.id, result);
                  }
                },
              ),
              ListTile(
                leading: Icon(
                  task.done ? Icons.undo : Icons.check,
                ),
                title: Text(task.done ? 'Mark incomplete' : 'Complete'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _completeTask(task);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Remove'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  widget.taskState.removeTask(task.id);
                },
              ),
            ],
          ),
        );
      },
    );
  }


  List<Task> _displayTasks(List<Task> tasks) {
    var result = tasks;
    final filter = _controller.text;
    if (filter.isNotEmpty) {
      final lower = filter.toLowerCase();
      result = result
          .where((t) => t.title.toLowerCase().contains(lower))
          .toList();
    }
    if (widget.settingsState.completedToBottom) {
      result = [
        ...result.where((t) => !t.done),
        ...result.where((t) => t.done),
      ];
    }
    return result;
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
                listenable: Listenable.merge([widget.taskState, _controller, widget.settingsState]),
                builder: (context, _) {
                  final tasks = _displayTasks(widget.taskState.tasks);
                  return NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollStartNotification) {
                        _cumulativeOverscroll = 0;
                      } else if (notification is OverscrollNotification) {
                        _onOverscroll(notification);
                      }
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
                            widget.onReorderStart(),
                        onReorderEnd: (_) =>
                            widget.onReorderEnd(),
                        onReorder: widget.taskState.reorder,
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return Opacity(
                            key: ValueKey(task.id),
                            opacity: task.done ? 0.4 : 1.0,
                            child: _SwipeToDismiss(
                              onDismissed: () =>
                                  widget.taskState.removeTask(task.id),
                              child: AppLabel(
                                label: task.title,
                                onTap: () => _completeTask(task),
                                onLongPress: () =>
                                    _showTaskOptions(context, task),
                                textDecoration: task.done
                                    ? TextDecoration.lineThrough
                                    : null,
                                decorationThickness:
                                    task.done ? 1.5 : null,
                                trailing:
                                    ReorderableDelayedDragStartListener(
                                  index: index,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 12,
                                        right: 20,
                                      ),
                                      child: Icon(
                                        Icons.drag_handle,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withAlpha(60),
                                      ),
                                    ),
                                  ),
                                ),
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

class _SwipeToDismiss extends StatefulWidget {
  const _SwipeToDismiss({
    required this.onDismissed,
    required this.child,
  });

  final VoidCallback onDismissed;
  final Widget child;

  @override
  State<_SwipeToDismiss> createState() => _SwipeToDismissState();
}

class _SwipeToDismissState extends State<_SwipeToDismiss> {
  Offset? _start;
  double _dx = 0;
  bool _tracking = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (e) {
        _start = e.position;
        _dx = 0;
        _tracking = false;
      },
      onPointerMove: (e) {
        final start = _start;
        if (start == null) return;
        final dx = e.position.dx - start.dx;
        final dy = (e.position.dy - start.dy).abs();
        if (!_tracking) {
          // Only start tracking if clearly horizontal (2x ratio).
          if (dx.abs() < 20) return;
          if (dx.abs() > dy * 2 && dx > 0) {
            _tracking = true;
          } else {
            _start = null;
            return;
          }
        }
        setState(() => _dx = (dx - 20).clamp(0.0, double.infinity));
      },
      onPointerUp: (_) {
        if (_tracking) {
          final screenWidth = MediaQuery.sizeOf(context).width;
          if (_dx > screenWidth * 0.3) {
            widget.onDismissed();
          }
          setState(() => _dx = 0);
        }
        _start = null;
        _tracking = false;
      },
      onPointerCancel: (_) {
        if (_tracking) setState(() => _dx = 0);
        _start = null;
        _tracking = false;
      },
      child: Transform.translate(
        offset: Offset(_dx, 0),
        child: Opacity(
          opacity: _dx > 0 ? (1 - _dx / MediaQuery.sizeOf(context).width).clamp(0.3, 1.0) : 1.0,
          child: widget.child,
        ),
      ),
    );
  }
}



