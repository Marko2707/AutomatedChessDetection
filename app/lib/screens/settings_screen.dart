// settings_screen.dart
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Dark Mode'),
            value: false,
            onChanged: (bool value) {
              // Toggle dark mode here
            },
          ),
          // Add more settings here
        ],
      ),
    );
  }
}