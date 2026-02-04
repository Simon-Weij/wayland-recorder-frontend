import 'package:flutter/material.dart';
import 'components/sidebar.dart';
import 'colors.dart';
import 'views/home.dart';
import 'views/settings.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  Widget currentPage = const HomePage();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Row(
          children: [
            Sidebar(
              footer: const UserTile(),
              children: [
                SidebarItem(icon: Icons.home, label: 'Home', onTap: () => setState(() => currentPage = const HomePage())),
                SidebarItem(
                  icon: Icons.settings,
                  label: 'Settings',
                  onTap: () => setState(() => currentPage = const SettingsPage()),
                ),
              ],
            ),
            Expanded(
              child: Container(
                color: AppColors.background,
                child: currentPage,
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
