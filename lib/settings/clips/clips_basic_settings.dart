import 'package:flutter/material.dart';
import 'clips_settings_model.dart';
import 'clips_controller.dart';
import 'clips_widgets.dart';
import '../hotkeys/hotkey_input.dart';

class ClipsBasicSettings extends StatelessWidget {
  final ClipsSettings settings;
  final ClipsController controller;
  final Function(VoidCallback) onUpdate;

  const ClipsBasicSettings({
    super.key,
    required this.settings,
    required this.controller,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HotkeyInput(controller: controller.hotkeyController),
        ClipsWidgets.buildPathInputTile(
          title: 'Output Path',
          subtitle: 'Custom file path for recordings',
          controller: controller.outputPathController,
          onBrowse: () => ClipsWidgets.pickDirectory(
            controller.outputPathController,
          ),
        ),
        ClipsWidgets.buildDropdownTile(
          title: 'Cursor Mode',
          subtitle: 'How to handle the cursor',
          value: settings.cursorMode,
          items: const ['hidden', 'embedded', 'metadata'],
          onChanged: (value) => onUpdate(() => settings.cursorMode = value!),
        ),
        ClipsWidgets.buildDropdownTile(
          title: 'Video Codec',
          subtitle: 'Compression codec',
          value: settings.codec,
          items: const ['vp8', 'vp9', 'h264', 'x264'],
          onChanged: (value) => onUpdate(() => settings.codec = value!),
        ),
        ClipsWidgets.buildDropdownTile(
          title: 'Container Format',
          subtitle: 'File format',
          value: settings.container,
          items: const ['webm', 'mp4', 'mkv'],
          onChanged: (value) => onUpdate(() => settings.container = value!),
        ),
        ClipsWidgets.buildInlineNumberInputTile(
          title: 'Quality (Bitrate)',
          subtitle: 'Target bitrate (1000000-50000000)',
          controller: controller.qualityController,
        ),
        ClipsWidgets.buildSwitchTile(
          title: 'Record System Audio',
          subtitle: 'Capture audio from system/monitor',
          value: settings.audioMonitor,
          onChanged: (value) => onUpdate(() => settings.audioMonitor = value),
        ),
        ClipsWidgets.buildSwitchTile(
          title: 'Record Microphone',
          subtitle: 'Capture audio from microphone',
          value: settings.audioMic,
          onChanged: (value) => onUpdate(() => settings.audioMic = value),
        ),
      ],
    );
  }
}
