import 'package:flutter/material.dart';
import '../colors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'settings',
        style: TextStyle(color: AppColors.text, fontSize: 24),
      ),
    );
  }
}