// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/logger.dart';
import '../../../core/theme/app_colors.dart';

class SettingsService {
  static Future<Map<String, dynamic>> loadSettings() async {
    try {
      final configDir = Directory(
        '${Platform.environment['HOME']}/.config/wayland-recorder',
      );
      final settingsFile = File('${configDir.path}/settings.json');

      if (await settingsFile.exists()) {
        final content = await settingsFile.readAsString();
        final settings = jsonDecode(content) as Map<String, dynamic>;
        logger.i('Settings loaded successfully');
        return settings;
      }
    } catch (e, st) {
      logger.w('Failed to load settings', error: e, stackTrace: st);
    }
    return {};
  }

  static Future<bool> saveSettings({
    required BuildContext context,
    required String cursorMode,
    required TextEditingController outputPathController,
    required String codec,
    required String container,
    required TextEditingController encoderSpeedController,
    required TextEditingController qualityController,
    required bool audioMonitor,
    required bool audioMic,
    required TextEditingController bufferDurationController,
    required TextEditingController segmentDurationController,
    required TextEditingController tempDirController,
    required TextEditingController hotkeyController,
  }) async {
    try {
      final encoderSpeed = int.tryParse(encoderSpeedController.text);
      final quality = int.tryParse(qualityController.text);
      final bufferDuration = int.tryParse(bufferDurationController.text);
      final segmentDuration = int.tryParse(segmentDurationController.text);

      if (encoderSpeed == null || encoderSpeed < 1 || encoderSpeed > 10) {
        _showError(context, 'Encoder speed must be a number between 1 and 10');
        return false;
      }
      if (quality == null || quality < 1000000 || quality > 50000000) {
        _showError(
          context,
          'Quality must be a number between 1000000 and 50000000',
        );
        return false;
      }
      if (bufferDuration == null ||
          bufferDuration < 5 ||
          bufferDuration > 300) {
        _showError(
          context,
          'Buffer duration must be a number between 5 and 300',
        );
        return false;
      }
      if (segmentDuration == null ||
          segmentDuration < 1 ||
          segmentDuration > 60) {
        _showError(
          context,
          'Segment duration must be a number between 1 and 60',
        );
        return false;
      }

      final settings = {
        'cursorMode': cursorMode,
        'outputPath': outputPathController.text,
        'hotkey': hotkeyController.text,
        'codec': codec,
        'container': container,
        'encoderSpeed': encoderSpeed,
        'quality': quality,
        'audioMonitor': audioMonitor,
        'audioMic': audioMic,
        'bufferDuration': bufferDuration,
        'segmentDuration': segmentDuration,
        'tempDir': tempDirController.text,
      };

      final configDir = Directory(
        '${Platform.environment['HOME']}/.config/wayland-recorder',
      );
      if (!await configDir.exists()) {
        await configDir.create(recursive: true);
      }

      final settingsFile = File('${configDir.path}/settings.json');
      await settingsFile.writeAsString(jsonEncode(settings));
      logger.i('Settings saved successfully');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings saved'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
      return true;
    } catch (e, st) {
      logger.e('Failed to save settings', error: e, stackTrace: st);
      if (context.mounted) {
        _showError(context, 'Failed to save settings: $e');
      }
      return false;
    }
  }

  static void _showError(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.accent,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  static Future<void> pickDirectory(TextEditingController controller) async {
    try {
      final result = await FilePicker.platform.getDirectoryPath();
      if (result != null) {
        controller.text = result;
        logger.i('Directory picked: $result');
      }
    } catch (e, st) {
      logger.w('Failed to pick directory', error: e, stackTrace: st);
    }
  }
}
