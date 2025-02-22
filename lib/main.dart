import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'splash_screen.dart';

List<CameraDescription>? cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),//home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Detected Chessboard'),
      ),
      body: Stack(
        children: [
          Container(color: Colors.grey[300]),

          // 左上角菜单按钮
          Positioned(
            top: 20,
            left: 20,
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.menu, size: 30, color: Colors.blue),
              onSelected: (String value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Selected: $value')),
                );
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(value: 'Settings', child: Text('Settings')),
                const PopupMenuItem(value: 'Volume', child: Text('Volume')),
                const PopupMenuItem(value: 'History', child: Text('History')),
              ],
            ),
          ),

          // 拍照按钮
          Center(
            child: GestureDetector(
              onTap: () async {
                if (cameras != null && cameras!.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CameraPage(cameras: cameras!),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No cameras available')),
                  );
                }
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 40),
              ),
            ),
          ),

          // 左下角上传图片按钮
          Positioned(
            bottom: 20,
            left: 20,
            child: ElevatedButton(
              onPressed: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? image = await picker.pickImage(source: ImageSource.gallery);

                if (image != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Select Picture From: ${image.path}')),
                  );
                }
              },
              child: const Text('Upload Image'),
            ),
          ),
        ],
      ),
    );
  }
}

class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraPage({Key? key, required this.cameras}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.cameras[0], ResolutionPreset.high);
    _controller?.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

// 请求权限
Future<void> _requestPermissions() async {
  await Permission.camera.request();
  await Permission.storage.request();
}

// 拍照并保存到相册
Future<void> _takePicture() async {
  try {
    if (!_controller!.value.isInitialized) return;

    // 拍照
    XFile picture = await _controller!.takePicture();

    // 获取私有存储目录（根据 Android 和 iOS 自动选择）
    Directory appDir = await getApplicationDocumentsDirectory();
    String saveDir = path.join(appDir.path, "chess_images");

    // 创建 `chess_images` 目录
    await Directory(saveDir).create(recursive: true);

    // 目标路径
    String targetPath = path.join(saveDir, "chess_${DateTime.now().millisecondsSinceEpoch}.jpg");

    // 移动图片到目标目录
    File savedImage = await File(picture.path).copy(targetPath);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Save Image: ${savedImage.path}')),
    );

    print("Image Path: ${savedImage.path}");

  } catch (e) {
    print("Shoot Error: $e");
  }
}



  @override
  Widget build(BuildContext context) {
    if (!_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        CameraPreview(_controller!),

        Positioned(
          bottom: 20,
          left: MediaQuery.of(context).size.width / 2 - 30,
          child: FloatingActionButton(
            onPressed: _takePicture,
            child: const Icon(Icons.camera),
          ),
        ),
      ],
    );
  }
}
