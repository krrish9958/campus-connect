import 'package:campus_connect/services/notes_service.dart';
import 'package:flutter/material.dart';

class UploadNotesScreen extends StatelessWidget {
  UploadNotesScreen({super.key});

  final _service = NotesService();
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final urlCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Notes")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            TextField(
              controller: urlCtrl,
              decoration: const InputDecoration(labelText: "File URL"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _service.uploadNote(
                  title: titleCtrl.text,
                  description: descCtrl.text,
                  fileUrl: urlCtrl.text,
                );
                Navigator.pop(context);
              },
              child: const Text("Upload"),
            ),
          ],
        ),
      ),
    );
  }
}
