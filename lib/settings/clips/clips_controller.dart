// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import 'package:flutter/material.dart';
import 'clips_settings_model.dart';
import 'clips_settings_service.dart';

class ClipsController {
  final ClipsSettings settings;
  final TextEditingController outputPathController;
  final TextEditingController encoderSpeedController;
  final TextEditingController qualityController;
  final TextEditingController bufferDurationController;
  final TextEditingController segmentDurationController;
  final TextEditingController tempDirController;
  final TextEditingController hotkeyController;

  ClipsController(this.settings)
    : outputPathController = TextEditingController(),
      encoderSpeedController = TextEditingController(),
      qualityController = TextEditingController(),
      bufferDurationController = TextEditingController(),
      segmentDurationController = TextEditingController(),
      tempDirController = TextEditingController(),
      hotkeyController = TextEditingController();

  void updateControllers() {
    outputPathController.text = settings.outputPath;
    encoderSpeedController.text = settings.encoderSpeed.toString();
    qualityController.text = settings.quality.toString();
    bufferDurationController.text = settings.bufferDuration.toString();
    segmentDurationController.text = settings.segmentDuration.toString();
    tempDirController.text = settings.tempDir;
    hotkeyController.text = settings.hotkey;
  }

  Future<String?> saveSettings() async {
    final encoderSpeed = int.tryParse(encoderSpeedController.text);
    final quality = int.tryParse(qualityController.text);
    final bufferDuration = int.tryParse(bufferDurationController.text);
    final segmentDuration = int.tryParse(segmentDurationController.text);

    if (encoderSpeed == null ||
        quality == null ||
        bufferDuration == null ||
        segmentDuration == null) {
      return 'Please enter valid numbers for all fields';
    }

    settings.outputPath = outputPathController.text;
    settings.encoderSpeed = encoderSpeed;
    settings.quality = quality;
    settings.bufferDuration = bufferDuration;
    settings.segmentDuration = segmentDuration;
    settings.tempDir = tempDirController.text;
    settings.hotkey = hotkeyController.text;

    final validationError = ClipsSettingsService.validateSettings(settings);
    if (validationError != null) {
      return validationError;
    }

    try {
      await ClipsSettingsService.saveSettings(settings);
      return null;
    } catch (e) {
      return 'Failed to save settings: $e';
    }
  }

  void dispose() {
    outputPathController.dispose();
    tempDirController.dispose();
    encoderSpeedController.dispose();
    qualityController.dispose();
    bufferDurationController.dispose();
    segmentDurationController.dispose();
    hotkeyController.dispose();
  }
}
