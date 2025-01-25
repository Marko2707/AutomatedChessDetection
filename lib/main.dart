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
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GUI Demo'),
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
                    SnackBar(content: Text('已选择图片: ${image.path}')),
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
    await _controller!.initialize();

    // 请求权限
    await _requestPermissions();

    // 获取 DCIM/Camera 目录（系统相册目录）
    final String dirPath = '/storage/emulated/0/DCIM/Camera';
    await Directory(dirPath).create(recursive: true);

    // 设置图片路径
    final String imagePath = '$dirPath/${DateTime.now().millisecondsSinceEpoch}.jpg';

    // 拍照并保存
    await _controller!.takePicture().then((file) {
      File(file.path).copy(imagePath);
    });

    // 通知系统刷新相册
    final result = await Process.run('am', ['broadcast', '-a', 'android.intent.action.MEDIA_SCANNER_SCAN_FILE', '-d', 'file://$imagePath']);
    print(result.stdout);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('照片已保存到: $imagePath')),
    );
  } catch (e) {
    print(e);
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
