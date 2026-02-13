// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'core/logger.dart';
import 'features/settings/subfeatures/videos/videos_page.dart';
import 'shared/widgets/sidebar.dart';
import 'core/theme/app_colors.dart';
import 'features/home/pages/home_page.dart';
import 'features/settings/pages/settings_page.dart';
import 'shared/widgets/icons/play.dart';
import 'shared/widgets/icons/stop.dart';
import 'features/recorder/services/recorder_service.dart';
import 'shared/widgets/user_tile.dart';

void main() {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    logger.e(
      'Flutter Error',
      error: details.exception,
      stackTrace: details.stack,
    );
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    logger.e('Platform Error', error: error, stackTrace: stack);
    return true;
  };

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

                            final pid = await RecorderService.startStream();

                            if (pid != null) {
                              recordingPid = pid.toString();
                              logger.i('Recording started with PID: $pid');
                            } else {
                              logger.w(
                                'Failed to capture PID from recording process',
                              );
                              setState(() => _isPlaying = false);
                            }
                          } else {
                            if (recordingPid.isNotEmpty) {
                              Process.killPid(int.parse(recordingPid));
                              logger.i(
                                'Killed recording process with PID: $recordingPid',
                              );
                            } else {
                              logger.w(
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
                SidebarItem(
                  icon: Icons.video_call_outlined,
                  label: 'Videos',
                  onTap: () => setState(() => currentPage = VideosPage()),
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
