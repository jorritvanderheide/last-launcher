import 'package:flutter/material.dart';

class AppSearchField extends StatelessWidget {
  const AppSearchField({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmit,
    super.key,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        onSubmitted: (_) => onSubmit(),
        textInputAction: TextInputAction.go,
        decoration: const InputDecoration(
          hintText: 'Search apps',
          prefixIcon: Icon(Icons.search),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}
