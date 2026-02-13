// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import 'dart:convert';
import 'dart:io';
import 'clips_settings_model.dart';

class ClipsSettingsService {
  static Future<ClipsSettings> loadSettings() async {
    try {
      final configDir = Directory(
        '${Platform.environment['HOME']}/.config/wayland-recorder',
      );
      final settingsFile = File('${configDir.path}/settings.json');

      if (await settingsFile.exists()) {
        final jsonString = await settingsFile.readAsString();
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        return ClipsSettings.fromJson(json);
      }
    } catch (e) {
      throw Exception('Failed to load settings: $e');
    }

    return ClipsSettings();
  }

  static Future<void> saveSettings(ClipsSettings settings) async {
    try {
      final configDir = Directory(
        '${Platform.environment['HOME']}/.config/wayland-recorder',
      );
      if (!await configDir.exists()) {
        await configDir.create(recursive: true);
      }

      final settingsFile = File('${configDir.path}/settings.json');
      await settingsFile.writeAsString(jsonEncode(settings.toJson()));
    } catch (e) {
      throw Exception('Failed to save settings: $e');
    }
  }

  static String? validateSettings(ClipsSettings settings) {
    if (settings.encoderSpeed < 1 || settings.encoderSpeed > 10) {
      return 'Encoder speed must be a number between 1 and 10';
    }
    if (settings.quality < 1000000 || settings.quality > 50000000) {
      return 'Quality must be a number between 1000000 and 50000000';
    }
    if (settings.bufferDuration < 5 || settings.bufferDuration > 300) {
      return 'Buffer duration must be a number between 5 and 300';
    }
    if (settings.segmentDuration < 1 || settings.segmentDuration > 60) {
      return 'Segment duration must be a number between 1 and 60';
    }
    return null;
  }
}
