import 'package:flutter/material.dart';
import 'main.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("Welcome Screen Loaded");
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 背景图片
          Image.asset(
            'assets/Welcome.png', // 你的欢迎页面背景图片
            fit: BoxFit.fill,
          ),

          // 居中的内容
          Column(
            mainAxisAlignment: MainAxisAlignment.center, // 让内容垂直居中
            children: [
              Text(
                'Welcome to Chess Converter',
                style: TextStyle(
                  fontSize: 26, // 设置字体大小
                  fontWeight: FontWeight.bold, // 加粗字体
                  color: Colors.white, // 适配你的背景颜色
                ),
              ),
              SizedBox(height: 20), // 增加间距

              // “开始使用”按钮
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: TextStyle(fontSize: 24),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          HomePage(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                      transitionDuration:
                          Duration(milliseconds: 1500), // 设置动画时长
                    ),
                  );
                },
                child: Text('Start'),
              ),
            ],
          ),

          // 左上角的“用户手册”按钮
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.info, color: Colors.white60, size: 40),
              onPressed: () {
                _showUserManual(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showUserManual(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('User Instruction'),
          content: SingleChildScrollView(
            child: Text('Welcome to this application!\n\n'
                '1. Click the Getting Started button to enter the photo page.\n'
                '2. The bottom left corner allows you to upload local images for analysis.\n'
                '3. Please grant camera and storage privileges for normal use.'),
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
