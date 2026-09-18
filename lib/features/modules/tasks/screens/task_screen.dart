import 'package:flutter/material.dart';
import 'package:last_launcher/l10n/app_localizations.dart';
import 'package:last_launcher/shared/search_focus_controller.dart';
import 'package:last_launcher/shared/widgets/search_field.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/features/modules/tasks/task.dart';
import 'package:last_launcher/features/modules/tasks/task_state.dart';
import 'package:last_launcher/shared/widgets/app_label.dart';
import 'package:last_launcher/shared/widgets/appearance_scope.dart';
import 'package:last_launcher/shared/widgets/action_row.dart';
import 'package:last_launcher/shared/widgets/fade_overflow.dart';
import 'package:last_launcher/shared/widgets/rename_dialog.dart';

/// Opacity of completed tasks.
const _doneOpacity = 0.6;

/// Alpha of the empty-state hint text.
const _emptyTextAlpha = 130;

/// Horizontal travel before a swipe starts dragging a row.
const _swipeSlop = 20.0;

/// Fraction of the screen a row must travel to be dismissed.
const _swipeDismissFraction = 0.3;

/// Opacity a row can fade to while being swiped away.
const _swipeMinOpacity = 0.3;

class TaskScreen extends StatefulWidget {
  const TaskScreen({
    required this.taskState,
    required this.settingsState,
    required this.isVisible,
    required this.onReorderStart,
    required this.onReorderEnd,
    this.scrollLocked = false,
    this.swipeRight = true,
    super.key,
  });

  final TaskState taskState;
  final SettingsState settingsState;
  final bool isVisible;
  final VoidCallback onReorderStart;
  final VoidCallback onReorderEnd;
  final bool scrollLocked;
  final bool swipeRight;

  @override
  State<TaskScreen> createState() => TaskScreenState();
}

class TaskScreenState extends State<TaskScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  late final _focus = SearchFocusController(
    autoKeyboard: () => _autoKeyboard,
    overscrollPolicy: OverscrollPolicy.cumulative,
  );

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
  bool get _autoKeyboard => widget.settingsState.autoKeyboardTasks.value;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(TaskScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _focus.panelOpened();
    } else if (!widget.isVisible && oldWidget.isVisible) {
      _focus.panelClosed();
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
    _focus.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_isReordering) return;
    if (_activeTaskId != null) setState(() => _activeTaskId = null);
    _focus.scrolled(_scrollController.offset);
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
    _focus.submitted();
  }

  void _completeTask(Task task) {
    if (!task.done && widget.settingsState.removeOnComplete.value) {
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
          opacity: task.done ? _doneOpacity : 1.0,
          leading: leading,
        ),
      );
    }
    return KeyedSubtree(
      key: ValueKey(task.id),
      child: _SwipeToDismiss(
        swipeRight: widget.swipeRight,
        onDismissed: () => widget.taskState.removeTask(task.id),
        child: AppLabel(
          label: task.title,
          onTap: task.done ? null : () => _renameTask(context, task),
          onLongPress: () => setState(
            () => _activeTaskId = _activeTaskId == task.id ? null : task.id,
          ),
          opacity: task.done ? _doneOpacity : 1.0,
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
            focusNode: _focus.node,
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
                  if (!widget.settingsState.showHints.value) {
                    return const SizedBox.shrink();
                  }
                  final l10n = AppLocalizations.of(context)!;
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
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
                          textAlign: AppearanceScope.of(context).labelAlign,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontSize: AppLabel.fontSizeOf(context),
                                color: Theme.of(context).colorScheme.onSurface
                                    .withAlpha(_emptyTextAlpha),
                              ),
                        );
                      },
                    ),
                  );
                }
                return NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollStartNotification) {
                      _focus.scrollStarted();
                    } else if (notification is OverscrollNotification) {
                      _focus.overscrolled(notification.overscroll);
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
  const _SwipeToDismiss({
    required this.onDismissed,
    required this.child,
    this.swipeRight = true,
  });

  final VoidCallback onDismissed;
  final Widget child;
  final bool swipeRight;

  @override
  State<_SwipeToDismiss> createState() => _SwipeToDismissState();
}

class _SwipeToDismissState extends State<_SwipeToDismiss>
    with SingleTickerProviderStateMixin {
  Offset? _start;
  // Distance swiped past the threshold in the dismiss direction (always >= 0).
  double _progress = 0;
  double _snapFrom = 0;
  bool _tracking = false;
  late final AnimationController _snapBack;

  int get _sign => widget.swipeRight ? 1 : -1;

  @override
  void initState() {
    super.initState();
    _snapBack =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 150),
        )..addListener(() {
          final t = Curves.easeOut.transform(_snapBack.value);
          setState(() => _progress = _snapFrom * (1 - t));
        });
  }

  @override
  void dispose() {
    _snapBack.dispose();
    super.dispose();
  }

  void _animateSnapBack() {
    _snapFrom = _progress;
    _snapBack.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (e) {
        _snapBack.stop();
        _start = e.position;
        _progress = 0;
        _tracking = false;
      },
      onPointerMove: (e) {
        final start = _start;
        if (start == null) return;
        final dx = (e.position.dx - start.dx) * _sign;
        final dy = (e.position.dy - start.dy).abs();
        if (!_tracking) {
          if (dx.abs() < _swipeSlop) return;
          if (dx.abs() > dy * 2 && dx > 0) {
            _tracking = true;
          } else {
            _start = null;
            return;
          }
        }
        setState(
          () => _progress = (dx - _swipeSlop).clamp(0.0, double.infinity),
        );
      },
      onPointerUp: (_) {
        if (_tracking) {
          final screenWidth = MediaQuery.sizeOf(context).width;
          if (_progress > screenWidth * _swipeDismissFraction) {
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
        offset: Offset(_progress * _sign, 0),
        child: Opacity(
          opacity: _progress > 0
              ? (1 - _progress / MediaQuery.sizeOf(context).width).clamp(
                  _swipeMinOpacity,
                  1.0,
                )
              : 1.0,
          child: widget.child,
        ),
      ),
    );
  }
}
