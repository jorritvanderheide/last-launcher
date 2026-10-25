import 'package:flutter/material.dart';
import 'package:last_launcher/l10n/app_localizations.dart';
import 'package:last_launcher/shared/search_focus_controller.dart';
import 'package:last_launcher/shared/widgets/search_field.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/features/modules/tasks/subtasks.dart';
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

/// Opacity of the subtasks of a row being dragged, which move along with it.
const _draggedSubtaskOpacity = 0.3;

/// How long a dragged row takes to slide to its new indent.
const _indentDuration = Duration(milliseconds: 100);

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
    _dragIndent.dispose();
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

  /// The row being dragged, from the moment a hold lifts it.
  int? _dragFrom;
  final _hold = HoldTracker();

  /// Where the finger is across the screen, and where it was when the row
  /// was lifted: how far it went sideways decides the indent.
  double _pointerX = 0;
  double _dragStartX = 0;

  /// Whether the lifted row was a subtask, and whether it will be one where
  /// it's dropped. The dragged row shows the difference as it goes.
  bool _dragWasIndented = false;
  final _dragIndent = ValueNotifier(false);

  /// The lifted row's subtasks, dimmed while they wait to move along.
  Set<String> _dragSubtasks = const {};

  void _onReorderStart(List<Task> group, int index) {
    _isReordering = true;
    _dragFrom = index;
    _dragStartX = _pointerX;
    _dragWasIndented = group[index].indented;
    _dragIndent.value = _dragWasIndented;
    setState(() {
      // From the whole list: a search may hide some of them.
      _dragSubtasks = {
        for (final t in subtasksOf(widget.taskState.tasks, group[index].id))
          t.id,
      };
    });
    widget.onReorderStart();
  }

  void _onPointerMove(PointerMoveEvent event) {
    _pointerX = event.position.dx;
    if (_dragFrom == null) return;
    _dragIndent.value = indentAfterDrag(
      wasIndented: _dragWasIndented,
      dx: _pointerX - _dragStartX,
    );
  }

  /// Ends a drag within [group]. A hold let go without moving opens the
  /// row's actions; see HoldTracker.
  void _onReorderEnd(List<Task> group, int index) {
    _isReordering = false;
    widget.onReorderEnd();
    final from = _dragFrom;
    _dragFrom = null;
    setState(() => _dragSubtasks = const {});
    if (from == null) return;
    if (!_hold.moved) {
      setState(() => _activeTaskId = group[from].id);
    } else if (index == from || index == from + 1) {
      // Dropped where it was lifted: only the indent may have changed. Not a
      // move, since a search may hide the rows around it.
      if (_dragIndent.value != _dragWasIndented) {
        widget.taskState.indentTask(group[from].id, indent: _dragIndent.value);
      }
    }
  }

  /// A reorder Flutter reports once the drop has settled. Back where it was,
  /// from below, is `from + 1`, which [_onReorderEnd] already handled.
  void _onReorder(List<Task> group, int from, int to) {
    if (to == from + 1) return;
    _move(group, from, to);
  }

  /// Moves the row at [from] in [group] to the gap at [to], with the indent
  /// it was dropped with.
  void _move(List<Task> group, int from, int to) {
    widget.taskState.moveTask(
      group[from].id,
      after: rowAbove(group, from, to),
      indent: _dragIndent.value,
    );
  }

  /// The lifted row, shifted to the indent it will be dropped with.
  Widget _dragProxy(Widget child, int index, Animation<double> animation) {
    return dragProxyDecorator(
      ValueListenableBuilder<bool>(
        valueListenable: _dragIndent,
        builder: (context, indent, child) {
          final steps = (indent ? 1 : 0) - (_dragWasIndented ? 1 : 0);
          return TweenAnimationBuilder<double>(
            tween: Tween(end: steps * subtaskIndent),
            duration: _indentDuration,
            builder: (context, dx, child) =>
                Transform.translate(offset: Offset(dx, 0), child: child),
            child: child,
          );
        },
        child: child,
      ),
      index,
      animation,
    );
  }

  Widget _buildTaskItem(BuildContext context, Task task, int index) {
    final Widget leading = GestureDetector(
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

    final indent = EdgeInsets.only(left: task.indented ? subtaskIndent : 0);
    if (_activeTaskId == task.id) {
      return KeyedSubtree(
        key: ValueKey(task.id),
        child: Padding(
          padding: indent,
          child: ActionRow(
            label: task.title,
            actions: _taskActions(context, task),
            onClose: () => setState(() => _activeTaskId = null),
            textDecoration: task.done ? TextDecoration.lineThrough : null,
            decorationThickness: task.done ? 1.5 : null,
            opacity: task.done ? _doneOpacity : 1.0,
            leading: leading,
          ),
        ),
      );
    }
    // Press and hold to drag.
    return ReorderableDelayedDragStartListener(
      key: ValueKey(task.id),
      index: index,
      child: Opacity(
        opacity: _dragSubtasks.contains(task.id) ? _draggedSubtaskOpacity : 1,
        child: Padding(
          padding: indent,
          child: _SwipeToDismiss(
            swipeRight: widget.swipeRight,
            // A row being dragged to a new place isn't being swiped away.
            blocked: () => _isReordering,
            onDismissed: () => widget.taskState.removeTask(task.id),
            child: AppLabel(
              label: task.title,
              onTap: task.done ? null : () => _renameTask(context, task),
              opacity: task.done ? _doneOpacity : 1.0,
              textDecoration: task.done ? TextDecoration.lineThrough : null,
              decorationThickness: task.done ? 1.5 : null,
              leading: leading,
            ),
          ),
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
                bool matches(Task t) =>
                    filter.isEmpty || t.title.toLowerCase().contains(filter);
                final groups = taskGroups(widget.taskState.tasks);
                final incomplete = groups.todo.where(matches).toList();
                final complete = groups.done.where(matches).toList();

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
                    child: Listener(
                      onPointerDown: (event) => _pointerX = event.position.dx,
                      onPointerMove: _onPointerMove,
                      child: _hold.listener(
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
                                proxyDecorator: _dragProxy,
                                onReorderStart: (index) =>
                                    _onReorderStart(incomplete, index),
                                onReorderEnd: (index) =>
                                    _onReorderEnd(incomplete, index),
                                onReorder: (from, to) =>
                                    _onReorder(incomplete, from, to),
                                itemBuilder: (context, index) => _buildTaskItem(
                                  context,
                                  incomplete[index],
                                  index,
                                ),
                              ),
                            ),
                            if (incomplete.isNotEmpty && complete.isNotEmpty)
                              const SliverToBoxAdapter(
                                child: SizedBox(height: 24),
                              ),
                            SliverReorderableList(
                              itemCount: complete.length,
                              proxyDecorator: _dragProxy,
                              onReorderStart: (index) =>
                                  _onReorderStart(complete, index),
                              onReorderEnd: (index) =>
                                  _onReorderEnd(complete, index),
                              onReorder: (from, to) =>
                                  _onReorder(complete, from, to),
                              itemBuilder: (context, index) => _buildTaskItem(
                                context,
                                complete[index],
                                index,
                              ),
                            ),
                            const SliverToBoxAdapter(
                              child: SizedBox(height: 80),
                            ),
                          ],
                        ),
                      ),
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
    required this.blocked,
    required this.child,
    this.swipeRight = true,
  });

  final VoidCallback onDismissed;

  /// Asked on every move; while true the row doesn't swipe.
  final bool Function() blocked;
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
        if (widget.blocked()) {
          if (_tracking) _animateSnapBack();
          _start = null;
          _tracking = false;
          return;
        }
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
