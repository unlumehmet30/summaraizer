import 'package:flutter/material.dart';
import '../widgets/video_picker_widget.dart';
import '../widgets/prompt_input_widget.dart';
import '../widgets/result_display_widget.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String prompt = '';
  String result = '';

  void updatePrompt(String value) {
    setState(() {
      prompt = value;
    });
  }

  void updateResult(String value) {
    setState(() {
      result = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Video Assistant")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            VideoPickerWidget(),
            PromptInputWidget(onPromptChanged: updatePrompt),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // API gönderimi yapılacak
                updateResult("Örnek sonuç..."); // geçici
              },
              child: const Text("Gönder"),
            ),
            const SizedBox(height: 20),
            ResultDisplayWidget(result: result),
          ],
        ),
      ),
    );
  }
}
