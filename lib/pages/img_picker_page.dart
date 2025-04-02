import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';

class ImgPickerPage extends StatefulWidget {
  const ImgPickerPage({super.key});

  @override
  State<ImgPickerPage> createState() => _ImgPickerPageState();
}

class _ImgPickerPageState extends State<ImgPickerPage> {
  File? _image;
  File? _compressedImage;
  String? _compressionInfo; // 添加压缩信息状态变量
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
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  /// 压缩图片
  Future<File?> compressImage(File file) async {
    // 获取临时目录
    final tempDir = await getTemporaryDirectory();
    final targetPath =
        path.join(tempDir.path, '${DateTime.now().millisecondsSinceEpoch}.jpg');

    // 获取原图大小（以 KB 为单位）
    final originalSize = await file.length() / 1024;

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 90,
      minWidth: 1024,
      minHeight: 1024,
    );

    if (result != null) {
      final compressedSize = await File(result.path).length() / 1024;
      final compressionRatio =
          ((originalSize - compressedSize) / originalSize * 100)
              .toStringAsFixed(2);

      setState(() {
        _compressedImage = File(result.path);
        _compressionInfo =
            '原图大小: ${originalSize.toStringAsFixed(2)}KB\n压缩后大小: ${compressedSize.toStringAsFixed(2)}KB\n压缩率: $compressionRatio%';
      });

      Get.snackbar(
        '压缩成功',
        _compressionInfo!,
        backgroundColor: Colors.green.withOpacity(0.3),
        duration: Duration(seconds: 2),
      );
      return File(result.path);
    } else {
      setState(() {
        _compressionInfo = '压缩失败\n原图大小: ${originalSize.toStringAsFixed(2)}KB';
      });

      Get.snackbar(
        '压缩失败',
        '原图大小: ${originalSize.toStringAsFixed(2)}KB',
        backgroundColor: Colors.red.withOpacity(0.3),
        duration: Duration(seconds: 2),
      );
      return null;
    }
  }

  // 添加图片预览方法
  void _showImagePreview(File image) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () => Get.back(),
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 0.5,
            maxScale: 4,
            child: Image.file(
              image,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("imgPicker"),
        backgroundColor: Colors.amberAccent,
      ),
      body: SingleChildScrollView(
        // 添加滚动视图
        child: Padding(
          // 添加内边距
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // 原图
                  Expanded(
                    child: Column(
                      children: [
                        Text('原图'),
                        GestureDetector(
                          onTap: _image != null
                              ? () => _showImagePreview(_image!)
                              : null,
                          child: Container(
                            width: 150,
                            height: 200,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                            ),
                            child: _image != null
                                ? Image.file(_image!, fit: BoxFit.cover)
                                : Center(child: Text("请选择照片")),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16), // 添加间距
                  // 压缩后的图
                  if (_compressedImage != null)
                    Expanded(
                      child: Column(
                        children: [
                          Text('压缩后'),
                          GestureDetector(
                            onTap: () => _showImagePreview(_compressedImage!),
                            child: Container(
                              width: 150,
                              height: 200,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Image.file(_compressedImage!,
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              SizedBox(height: 20),
              // 移除重复的大图显示
              // Container(
              //   width: 300,
              //   height: 400,
              //   child: _image != null ? Image.file(_image!) : Text("请选择照片"),
              // ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: getImageFromGallery,
                child: Text("从相册选择单张照片"),
              ),
              SizedBox(height: 10), // 添加按钮间距
              ElevatedButton(
                onPressed: getImageFromCamera,
                child: Text("从相机选择单张照片"),
              ),
              SizedBox(height: 10), // 添加按钮间距
              if (_image != null)
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        compressImage(_image!);
                      },
                      child: Text("压缩照片"),
                    ),
                    if (_compressionInfo != null)
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            // color: Colors.grey[200],
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _compressionInfo!,
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
