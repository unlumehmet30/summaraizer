import 'package:flutter/material.dart';

class PromptInputWidget extends StatefulWidget {
  final Function(String) onPromptChanged;
  final Function()? onSubmit;

  const PromptInputWidget({
    super.key,
    required this.onPromptChanged,
    this.onSubmit,
  });

  @override
  State<PromptInputWidget> createState() => _PromptInputWidgetState();
}

class _PromptInputWidgetState extends State<PromptInputWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: const InputDecoration(labelText: "Ask anything"),
      onChanged: widget.onPromptChanged,
      onSubmitted: (_) {
        if (widget.onSubmit != null) {
          widget.onSubmit!();
        }
      },
    );
  }
}
