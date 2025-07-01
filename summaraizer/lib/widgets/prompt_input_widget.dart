import 'package:flutter/material.dart';

class PromptInputWidget extends StatelessWidget {
  final Function(String) onPromptChanged;

  const PromptInputWidget({super.key, required this.onPromptChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(labelText: "Ask anything"),
      onChanged: onPromptChanged,
    );
  }
}
