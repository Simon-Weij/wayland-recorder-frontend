import 'package:flutter/material.dart';
import 'components/sidebar.dart';
import 'colors.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Row(
          children: [
            Sidebar(
              footer: const UserTile(),
              children: [
                SidebarItem(icon: Icons.home, label: 'Home', onTap: () {}),
                SidebarItem(
                  icon: Icons.settings,
                  label: 'Settings',
                  onTap: () {},
                ),
              ],
            ),
            Expanded(
              child: Container(
                color: AppColors.background,
                child: const Center(
                  child: Text(
                    'Main Content',
                    style: TextStyle(color: AppColors.text, fontSize: 24),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserTile extends StatelessWidget {
  const UserTile({super.key});

  @override
  Widget build(BuildContext context) {
    return HoverableContainer(
      onTap: () {},
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      borderRadius: BorderRadius.zero,
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'User Name',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
