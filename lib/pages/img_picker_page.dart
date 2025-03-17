import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImgPickerPage extends StatefulWidget {
  const ImgPickerPage({super.key});

  @override
  State<ImgPickerPage> createState() => _ImgPickerPageState();
}

class _ImgPickerPageState extends State<ImgPickerPage> {
  File? _image;
  final picker = ImagePicker();
  Future getImageFromGallery() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future getImageFromCamera() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("imgPicker"),
        backgroundColor: Colors.amberAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 400,
              child: _image != null ? Image.file(_image!) : Text("请选择照片"),
            ),
            ElevatedButton(
              onPressed: getImageFromGallery,
              child: Text("从相册选择单张照片"),
            ),
            ElevatedButton(
              onPressed: getImageFromCamera,
              child: Text("从相机选择单张照片"),
            ),
          ],
        ),
      ),
    );
  }
}
