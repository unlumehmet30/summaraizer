import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class VideoPickerWidget extends StatefulWidget {
  const VideoPickerWidget({super.key});

  @override
  State<VideoPickerWidget> createState() => _VideoPickerWidgetState();
}

class _VideoPickerWidgetState extends State<VideoPickerWidget> {
  String? fileName;

  Future<void> pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null) {
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
