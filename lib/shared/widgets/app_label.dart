import 'package:flutter/material.dart';

class AppLabel extends StatelessWidget {
  const AppLabel({
    required this.label,
    required this.onTap,
    this.onLongPress,
    this.textDecoration,
    this.decorationThickness,
    this.trailing,
    super.key,
  });

  final String label;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final TextDecoration? textDecoration;
  final double? decorationThickness;
  final Widget? trailing;

  static const fontSize = 28.0;
  static const verticalPadding = 9.0;

  @override
  Widget build(BuildContext context) {
    final text = Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: trailing == null ? 20 : 0,
        top: verticalPadding,
        bottom: verticalPadding,
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontSize: fontSize,
          decoration: textDecoration,
          decorationThickness: decorationThickness,
        ),
      ),
    );

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: trailing == null
          ? text
          : IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: text),
                  SizedBox(
                    height: double.infinity,
                    child: trailing!,
                  ),
                ],
              ),
            ),
    );
  }
}
