// history_screen.dart
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('History')),
      body: ListView(
        children: [
          ListTile(title: Text('Position 1')),
          ListTile(title: Text('Position 2')),
          // Display recent positions here
        ],
      ),
    );
  }
}