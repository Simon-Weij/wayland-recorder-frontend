// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'components/sidebar.dart';
import 'colors.dart';
import 'views/home.dart';
import 'views/settings.dart';
import 'components/icons/play.dart';
import 'components/icons/stop.dart';
import 'stream/stream.dart';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  Widget currentPage = const HomePage();

  bool _isPlaying = false;

  Widget get _currentIcon => _isPlaying
      ? StopIcon(color: AppColors.textSecondary)
      : PlayIcon(color: AppColors.textSecondary);

  String recordingPid = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Row(
          children: [
            Sidebar(
              footer: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () async {
                          if (!_isPlaying) {
                            setState(() => _isPlaying = true);

                            final pid = await Stream.startStream();

                            if (pid != null) {
                              recordingPid = pid.toString();
                              Logger.root.info('Recording started with PID: $pid');
                            } else {
                              Logger.root.warning('Failed to capture PID from recording process');
                              setState(() => _isPlaying = false);
                            }
                          } else {
                            if (recordingPid.isNotEmpty) {
                              Process.killPid(int.parse(recordingPid));
                              Logger.root.info('Killed recording process with PID: $recordingPid');
                            } else {
                              Logger.root.warning(
                                'No PID found for the recording process.',
                              );
                            }
                            setState(() => _isPlaying = false);
                          }
                        },
                        child: SizedBox(
                          width: 64,
                          height: 64,
                          child: _currentIcon,
                        ),
                      ),
                    ],
                  ),
                  const UserTile(),
                ],
              ),
              children: [
                SidebarItem(
                  icon: Icons.home,
                  label: 'Home',
                  onTap: () => setState(() => currentPage = const HomePage()),
                ),
                SidebarItem(
                  icon: Icons.settings,
                  label: 'Settings',
                  onTap: () =>
                      setState(() => currentPage = const SettingsPage()),
                ),
              ],
            ),
            Expanded(
              child: Container(color: AppColors.background, child: currentPage),
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
