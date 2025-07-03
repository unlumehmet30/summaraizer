import 'package:flutter/material.dart';

class ResultDisplayWidget extends StatelessWidget {
  final String result;

  const ResultDisplayWidget({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Sonuç:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          SelectableText(
            result.isNotEmpty ? result : "Henüz sonuç yok",
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

