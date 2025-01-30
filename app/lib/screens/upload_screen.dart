// upload_screen.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'board_editor_screen.dart';

class UploadScreen extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      // Process the image here
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => EditorPage(title: 'Analysis Board', startFEN: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Image')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _pickImage(context),
          child: Text('Select Image'),
        ),
      ),
    );
  }
}