import 'package:flutter/material.dart';
import 'package:last_launcher/shared/widgets/app_label.dart';
import 'package:last_launcher/shared/widgets/appearance_scope.dart';

class AppSearchField extends StatelessWidget {
  const AppSearchField({
    required this.controller,
    required this.focusNode,
    this.onChanged,
    required this.onSubmit,
    super.key,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String>? onChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(
      context,
    ).textTheme.titleLarge?.copyWith(fontSize: AppLabel.fontSizeOf(context));
    final colorScheme = Theme.of(context).colorScheme;
    final appearance = AppearanceScope.of(context);

    if (appearance.terminalPrompt) {
      return _ExtraField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        onSubmit: onSubmit,
        style: style,
        color: colorScheme.onSurface,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: AppLabel.verticalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            focusNode: focusNode,
            onChanged: onChanged,
            onSubmitted: (_) => onSubmit(),
            cursorWidth: 0,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.go,
            style: style,
            decoration: const InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) {
              return AnimatedOpacity(
                duration: const Duration(milliseconds: 150),
                opacity: value.text.isEmpty ? 1 : 0,
                child: Container(
                  width: 32,
                  height: 2,
                  color: colorScheme.onSurface,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ExtraField extends StatelessWidget {
  const _ExtraField({
    required this.controller,
    required this.focusNode,
    this.onChanged,
    required this.onSubmit,
    required this.style,
    required this.color,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String>? onChanged;
  final VoidCallback onSubmit;
  final TextStyle? style;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: AppLabel.verticalPadding,
      ),
      child: Stack(
        children: [
          Opacity(
            opacity: 0,
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              onSubmitted: (_) => onSubmit(),
              cursorWidth: 0,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.go,
              style: style,
              decoration: const InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),
          IgnorePointer(
            child: ListenableBuilder(
              listenable: Listenable.merge([controller, focusNode]),
              builder: (context, _) {
                final text = controller.text;
                final focused = MediaQuery.viewInsetsOf(context).bottom > 0;
                return Row(
                  children: [
                    Text('\$ ', style: style),
                    Flexible(
                      child: Text(
                        text,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: style,
                      ),
                    ),
                    if (focused)
                      _BlinkingCursor(
                        color: color,
                        blink: AppearanceScope.of(context).animate,
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BlinkingCursor extends StatefulWidget {
  const _BlinkingCursor({required this.color, required this.blink});

  final Color color;

  /// When false the cursor is drawn steady.
  final bool blink;

  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _applyBlink();
  }

  @override
  void didUpdateWidget(_BlinkingCursor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.blink != oldWidget.blink) _applyBlink();
  }

  void _applyBlink() {
    if (widget.blink) {
      _controller.repeat(reverse: true);
    } else {
      _controller
        ..stop()
        ..value = 1;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Opacity(
          opacity: _controller.value.round().toDouble(),
          child: Text(
            '█',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: AppLabel.fontSizeOf(context),
              color: widget.color,
            ),
          ),
        );
      },
    );
  }
}
