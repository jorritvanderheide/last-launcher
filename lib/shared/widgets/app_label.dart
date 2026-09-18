import 'package:flutter/material.dart';
import 'package:last_launcher/shared/data/hints.dart';
import 'package:last_launcher/shared/widgets/appearance_scope.dart';
import 'package:last_launcher/shared/widgets/scanline_overlay.dart';

class AppLabel extends StatelessWidget {
  const AppLabel({
    required this.label,
    this.onTap,
    this.onLongPress,
    this.leading,
    this.textDecoration,
    this.decorationThickness,
    this.opacity = 1.0,
    this.hint,
    this.hintOpacity = 0.6,
    this.hintAlphaOnly = false,
    super.key,
  });

  final String label;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget? leading;
  final TextDecoration? textDecoration;
  final double? decorationThickness;
  final double opacity;
  final SubstringHint? hint;
  final double hintOpacity;
  final bool hintAlphaOnly;

  static const verticalPadding = 9.0;

  /// Label font size under the current text-size setting.
  static double fontSizeOf(BuildContext context) =>
      AppearanceScope.of(context).labelFontSize;

  /// Height of one label row: the text's line height plus its padding.
  static double itemHeightFor(double fontSize) =>
      fontSize * 1.2 + 2 * verticalPadding;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.titleLarge?.copyWith(
      fontSize: fontSizeOf(context),
      decoration: textDecoration,
      decorationThickness: decorationThickness,
    );

    final text = Padding(
      padding: EdgeInsets.only(
        left: leading == null ? 20 : 0,
        right: 20,
        top: verticalPadding,
        bottom: verticalPadding,
      ),
      // Aligns itself rather than relying on the parent to force full width.
      child: Align(
        alignment: Alignment(AppearanceScope.of(context).labelAlignX, 0),
        child: _GlitchText(
          label: label,
          style: style,
          hint: hint,
          hintOpacity: hintOpacity,
          hintAlphaOnly: hintAlphaOnly,
          textOpacity: opacity,
        ),
      ),
    );

    final tappable = Semantics(
      button: true,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        focusColor: Theme.of(context).colorScheme.onSurface.withAlpha(30),
        child: text,
      ),
    );

    final content = leading == null
        ? tappable
        : Row(
            children: [
              leading!,
              Expanded(child: tappable),
            ],
          );

    return content;
  }
}

class _GlitchText extends StatefulWidget {
  const _GlitchText({
    required this.label,
    required this.style,
    this.hint,
    this.hintOpacity = 0.6,
    this.hintAlphaOnly = false,
    this.textOpacity = 1.0,
  });

  final String label;
  final TextStyle? style;
  final SubstringHint? hint;
  final double hintOpacity;
  final bool hintAlphaOnly;
  final double textOpacity;

  @override
  State<_GlitchText> createState() => _GlitchTextState();
}

class _GlitchTextState extends State<_GlitchText> {
  // Lazily allocated only when the Extra theme is active. Saves one
  // GlobalKey per list item in the regular themes (drawer/home/tasks lists).
  GlobalKey? _key;

  double _getIntensity(ScanlineScope scope, GlobalKey key) {
    // Only glitch ~40% of labels per sweep, based on label hash + band position.
    if ((widget.label.hashCode + scope.bandY.toInt()) % 5 < 3) return 0;

    try {
      final box = key.currentContext?.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize || !box.attached) return 0;

      final globalY = box.localToGlobal(Offset.zero).dy;
      final widgetHeight = box.size.height;
      final bandTop = scope.bandY;
      final bandBottom = bandTop + scope.bandHeight;

      if (bandBottom < globalY || bandTop > globalY + widgetHeight) return 0;

      final overlapCenter =
          ((bandTop + bandBottom) / 2 - globalY) / widgetHeight;
      return (1 - (overlapCenter - 0.5).abs() * 2).clamp(0.0, 0.25);
    } catch (_) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scope = ScanlineScope.of(context);
    final animate = AppearanceScope.of(context).animate;

    Key? textKey;
    double intensity = 0;
    if (scope != null && scope.active && animate) {
      final key = _key ??= GlobalKey();
      textKey = key;
      intensity = _getIntensity(scope, key);
    }

    return Semantics(
      label: widget.label,
      excludeSemantics: true,
      child: _buildText(textKey, intensity),
    );
  }

  Widget _buildText(Key? textKey, double intensity) {
    final hint = widget.hint;
    if (hint != null &&
        intensity <= 0 &&
        hint.start + hint.length <= widget.label.length) {
      final before = widget.label.substring(0, hint.start);
      final match = widget.label.substring(
        hint.start,
        hint.start + hint.length,
      );
      final after = widget.label.substring(hint.start + hint.length);
      final style = widget.style;
      final dimAlpha = (widget.hintOpacity * 255).round();
      return Text.rich(
        TextSpan(
          style: style,
          children: [
            if (before.isNotEmpty)
              TextSpan(
                text: before,
                style: style?.copyWith(color: style.color?.withAlpha(dimAlpha)),
              ),
            ..._hintSpans(match, style, dimAlpha),
            if (after.isNotEmpty)
              TextSpan(
                text: after,
                style: style?.copyWith(color: style.color?.withAlpha(dimAlpha)),
              ),
          ],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: AppearanceScope.of(context).labelAlign,
      );
    }

    if (hint == null && widget.textOpacity < 1.0 && intensity <= 0) {
      final style = widget.style;
      final dimAlpha = (widget.textOpacity * 255).round();
      return Text.rich(
        TextSpan(
          style: style?.copyWith(color: style.color?.withAlpha(dimAlpha)),
          text: widget.label,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: AppearanceScope.of(context).labelAlign,
      );
    }

    return Text(
      key: textKey,
      intensity > 0 ? glitchText(widget.label, intensity) : widget.label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: AppearanceScope.of(context).labelAlign,
      style: widget.style,
    );
  }

  List<TextSpan> _hintSpans(String match, TextStyle? style, int dimAlpha) {
    if (!widget.hintAlphaOnly) return [TextSpan(text: match)];

    final dimmed = style?.copyWith(color: style.color?.withAlpha(dimAlpha));
    final spans = <TextSpan>[];
    int start = 0;
    for (int i = 0; i <= match.length; i++) {
      if (i == match.length || !RegExp(r'[a-zA-Z]').hasMatch(match[i])) {
        if (start < i) {
          spans.add(TextSpan(text: match.substring(start, i)));
        }
        if (i < match.length) {
          spans.add(TextSpan(text: match[i], style: dimmed));
        }
        start = i + 1;
      }
    }
    return spans;
  }
}

Widget dragProxyDecorator(
  Widget child,
  int index,
  Animation<double> animation,
) {
  return Material(
    color: Colors.transparent,
    child: Opacity(opacity: 0.6, child: child),
  );
}

Widget dragHandle(BuildContext context, int index) {
  return ReorderableDragStartListener(
    index: index,
    child: SizedBox.square(
      dimension: 48,
      child: Center(
        child: Icon(
          Icons.drag_indicator,
          size: 22,
          color: Theme.of(context).colorScheme.onSurface.withAlpha(130),
        ),
      ),
    ),
  );
}
