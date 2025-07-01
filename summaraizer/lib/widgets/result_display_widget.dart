import 'package:flutter/material.dart';

class ResultDisplayWidget extends StatelessWidget {
  final String result;

  const ResultDisplayWidget({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Sonuç:", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(result),
      ],
    );
  }
}
