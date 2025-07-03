import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
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
  String? filePath;
  bool loading = false;

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

  void updateFilePath(String path) {
    setState(() {
      filePath = path;
    });
  }

  Future<void> sendToServer() async {
    if (filePath == null) {
      updateResult("Lütfen önce bir video dosyası seçin.");
      return;
    }
    if (prompt.isEmpty) {
      updateResult("Lütfen bir prompt girin.");
      return;
    }

    setState(() {
      loading = true;
      result = '';
    });

    try {
      final dio = Dio();
      final formData = FormData.fromMap({
        "audio_file": await MultipartFile.fromFile(filePath!, filename: "audio.wav"),
        "prompt": prompt,
      });

      final response = await dio.post(
        "http://192.168.1.42:8000/process/",  // <-- Buraya kendi sunucu IP adresini yaz
        data: formData,
      );

      // Sunucudan gelen cevabı al
      final responseData = response.data;
      if (responseData is Map && responseData.containsKey('text')) {
        updateResult(responseData['text']);
      } else {
        updateResult(responseData.toString());
      }
    } catch (e) {
      updateResult("Sunucuya bağlanırken hata oluştu: $e");
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Video Assistant")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            VideoPickerWidget(onFileSelected: updateFilePath),
            PromptInputWidget(onPromptChanged: updatePrompt),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : sendToServer,
              child: Text(loading ? "Gönderiliyor..." : "Gönder"),
            ),
            const SizedBox(height: 20),
            ResultDisplayWidget(result: result),
          ],
        ),
      ),
    );
  }
}

