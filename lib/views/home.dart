import 'package:flutter/material.dart';
import '../colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'home',
        style: TextStyle(color: AppColors.text, fontSize: 24),
      ),
    );
  }
}
