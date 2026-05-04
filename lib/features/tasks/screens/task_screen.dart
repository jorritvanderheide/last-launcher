import 'package:flutter/material.dart';
import 'package:last_launcher/l10n/app_localizations.dart';
import 'package:last_launcher/shared/widgets/search_field.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/features/tasks/task.dart';
import 'package:last_launcher/features/tasks/task_state.dart';
import 'package:last_launcher/shared/widgets/app_label.dart';
import 'package:last_launcher/shared/widgets/action_row.dart';
import 'package:last_launcher/shared/widgets/fade_overflow.dart';
import 'package:last_launcher/shared/widgets/rename_dialog.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({
    required this.taskState,
    required this.settingsState,
    required this.isVisible,
    required this.onReorderStart,
    required this.onReorderEnd,
    this.scrollLocked = false,
    super.key,
  });

  final TaskState taskState;
  final SettingsState settingsState;
  final bool isVisible;
  final VoidCallback onReorderStart;
  final VoidCallback onReorderEnd;
  final bool scrollLocked;

  @override
  State<TaskScreen> createState() => TaskScreenState();
}

class TaskScreenState extends State<TaskScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _scrollController = ScrollController();
  double _cumulativeOverscroll = 0;

  late final Listenable _mergedState = Listenable.merge([
    widget.taskState,
    _controller,
    widget.settingsState,
  ]);

  bool dismissActions() {
    if (_activeTaskId == null) return false;
    setState(() => _activeTaskId = null);
    return true;
  }

  String? _activeTaskId;
  bool _isReordering = false;
  bool get _autoKeyboard => widget.settingsState.autoKeyboardTasks;

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
      _activeTaskId = null;
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
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
    if (_isReordering) return;
    if (_activeTaskId != null) setState(() => _activeTaskId = null);
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
    } else if (_cumulativeOverscroll < -20) {
      if (!_focusNode.hasFocus && _autoKeyboard) {
        _focusNode.requestFocus();
      }
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
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
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

  Future<void> _renameTask(BuildContext context, Task task) async {
    final result = await showRenameDialog(
      context: context,
      currentLabel: task.title,
      originalLabel: task.title,
    );
    if (result != null && result.isNotEmpty && result != task.title) {
      await widget.taskState.renameTask(task.id, result);
    }
  }

  List<ActionItem> _taskActions(BuildContext context, Task task) {
    final l10n = AppLocalizations.of(context)!;
    return [
      ActionItem(
        icon: Icons.delete_outline,
        label: l10n.actionRemove,
        onTap: () => widget.taskState.removeTask(task.id),
      ),
    ];
  }

  void _onReorderStart(int _) {
    _isReordering = true;
    widget.onReorderStart();
  }

  void _onReorderEnd(int _) {
    _isReordering = false;
    widget.onReorderEnd();
  }

  Widget _buildTaskItem(BuildContext context, Task task, int index) {
    final showHandle = _activeTaskId != null;
    final Widget leading = showHandle
        ? dragHandle(context, index)
        : GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _completeTask(task),
            child: SizedBox.square(
              dimension: 48,
              child: Center(
                child: Icon(
                  task.done ? Icons.check_box : Icons.check_box_outline_blank,
                  size: 22,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          );

    if (_activeTaskId == task.id) {
      return KeyedSubtree(
        key: ValueKey(task.id),
        child: ActionRow(
          label: task.title,
          actions: _taskActions(context, task),
          onClose: () => setState(() => _activeTaskId = null),
          textDecoration: task.done ? TextDecoration.lineThrough : null,
          decorationThickness: task.done ? 1.5 : null,
          opacity: task.done ? 0.6 : 1.0,
          leading: leading,
        ),
      );
    }
    return KeyedSubtree(
      key: ValueKey(task.id),
      child: _SwipeToDismiss(
        onDismissed: () => widget.taskState.removeTask(task.id),
        child: AppLabel(
          label: task.title,
          onTap: task.done ? null : () => _renameTask(context, task),
          onLongPress: () => setState(
            () => _activeTaskId = _activeTaskId == task.id ? null : task.id,
          ),
          opacity: task.done ? 0.6 : 1.0,
          textDecoration: task.done ? TextDecoration.lineThrough : null,
          decorationThickness: task.done ? 1.5 : null,
          leading: leading,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: (MediaQuery.sizeOf(context).height * 0.1 + 8).clamp(
              0,
              double.infinity,
            ),
          ),
          AppSearchField(
            controller: _controller,
            focusNode: _focusNode,
            onSubmit: _onSubmit,
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: _mergedState,
              builder: (context, _) {
                final filter = _controller.text.trim().toLowerCase();
                final filtered = filter.isEmpty
                    ? widget.taskState.tasks
                    : widget.taskState.tasks
                          .where((t) => t.title.toLowerCase().contains(filter))
                          .toList();
                final incomplete = filtered.where((t) => !t.done).toList();
                final complete = filtered.where((t) => t.done).toList();

                if (incomplete.isEmpty && complete.isEmpty) {
                  if (!widget.settingsState.showHints) {
                    return const SizedBox.shrink();
                  }
                  final l10n = AppLocalizations.of(context)!;
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      top: 32 + AppLabel.verticalPadding,
                    ),
                    child: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _controller,
                      builder: (context, value, _) {
                        final hint = value.text.trim().isEmpty
                            ? l10n.emptyTaskList
                            : l10n.returnToAddTask;
                        return Text(
                          hint,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontSize: AppLabel.fontSize,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withAlpha(130),
                              ),
                        );
                      },
                    ),
                  );
                }
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
                    child: CustomScrollView(
                      controller: _scrollController,
                      physics: widget.scrollLocked
                          ? const NeverScrollableScrollPhysics()
                          : const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.only(top: 32),
                          sliver: SliverReorderableList(
                            itemCount: incomplete.length,
                            proxyDecorator: dragProxyDecorator,
                            onReorderStart: _onReorderStart,
                            onReorderEnd: _onReorderEnd,
                            onReorder: (o, n) => widget.taskState
                                .reorderInGroup(o, n, done: false),
                            itemBuilder: (context, index) => _buildTaskItem(
                              context,
                              incomplete[index],
                              index,
                            ),
                          ),
                        ),
                        if (incomplete.isNotEmpty && complete.isNotEmpty)
                          const SliverToBoxAdapter(child: SizedBox(height: 24)),
                        SliverReorderableList(
                          itemCount: complete.length,
                          proxyDecorator: dragProxyDecorator,
                          onReorderStart: _onReorderStart,
                          onReorderEnd: _onReorderEnd,
                          onReorder: (o, n) =>
                              widget.taskState.reorderInGroup(o, n, done: true),
                          itemBuilder: (context, index) =>
                              _buildTaskItem(context, complete[index], index),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 80)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SwipeToDismiss extends StatefulWidget {
  const _SwipeToDismiss({required this.onDismissed, required this.child});

  final VoidCallback onDismissed;
  final Widget child;

  @override
  State<_SwipeToDismiss> createState() => _SwipeToDismissState();
}

class _SwipeToDismissState extends State<_SwipeToDismiss>
    with SingleTickerProviderStateMixin {
  Offset? _start;
  double _dx = 0;
  double _snapFrom = 0;
  bool _tracking = false;
  late final AnimationController _snapBack;

  @override
  void initState() {
    super.initState();
    _snapBack =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 150),
        )..addListener(() {
          final t = Curves.easeOut.transform(_snapBack.value);
          setState(() => _dx = _snapFrom * (1 - t));
        });
  }

  @override
  void dispose() {
    _snapBack.dispose();
    super.dispose();
  }

  void _animateSnapBack() {
    _snapFrom = _dx;
    _snapBack.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (e) {
        _snapBack.stop();
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
          } else {
            _animateSnapBack();
          }
        }
        _start = null;
        _tracking = false;
      },
      onPointerCancel: (_) {
        if (_tracking) _animateSnapBack();
        _start = null;
        _tracking = false;
      },
      child: Transform.translate(
        offset: Offset(_dx, 0),
        child: Opacity(
          opacity: _dx > 0
              ? (1 - _dx / MediaQuery.sizeOf(context).width).clamp(0.3, 1.0)
              : 1.0,
          child: widget.child,
        ),
      ),
    );
  }
}
