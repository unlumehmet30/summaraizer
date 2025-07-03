import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class VideoPickerWidget extends StatefulWidget {
  final Function(String) onFileSelected; // Dosya yolunu iletmek için callback

  const VideoPickerWidget({super.key, required this.onFileSelected});

  @override
  State<VideoPickerWidget> createState() => _VideoPickerWidgetState();
}

class _VideoPickerWidgetState extends State<VideoPickerWidget> {
  String? fileName;

  Future<void> pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null) {
      final path = result.files.single.path!;
      widget.onFileSelected(path);  // Dosya yolunu dışarıya ilet
      setState(() {
        fileName = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: pickVideo,
          child: const Text("Video Seç"),
        ),
        if (fileName != null) Text("Seçilen dosya: $fileName"),
      ],
    );
  }
}
