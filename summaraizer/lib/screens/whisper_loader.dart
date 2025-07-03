import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

class WhisperScreen extends StatefulWidget {
  const WhisperScreen({super.key});

  @override
  State<WhisperScreen> createState() => _WhisperScreenState();
}

class _WhisperScreenState extends State<WhisperScreen> {
  String? resultText;
  bool loading = false;
  TextEditingController promptController = TextEditingController();

  Future<void> uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);

    if (result == null) return;

    setState(() {
      loading = true;
      resultText = null;
    });

    final filePath = result.files.single.path!;
    final prompt = promptController.text;

    final dio = Dio();
    final formData = FormData.fromMap({
      "audio_file": await MultipartFile.fromFile(filePath, filename: "audio.wav"),
      "prompt": prompt,
    });

    try {
      final response = await dio.post(
        "http://192.168.1.42:8000/process/", // ⚠️ Kendi IP adresini gir
        data: formData,
      );

      setState(() {
        resultText = response.data.toString();
      });
    } catch (e) {
      setState(() {
        resultText = "Hata: $e";
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Whisper + Prompt")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: promptController,
              decoration: const InputDecoration(labelText: "Prompt (örn: özet çıkar)"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: loading ? null : uploadFile,
              child: Text(loading ? "Yükleniyor..." : "Ses Dosyası Gönder"),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: SelectableText(resultText ?? "Henüz sonuç yok"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
