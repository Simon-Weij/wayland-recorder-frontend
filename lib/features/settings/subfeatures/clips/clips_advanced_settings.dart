// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'clips_controller.dart';
import 'clips_widgets.dart';

class ClipsAdvancedSettings extends StatelessWidget {
  final ClipsController controller;
  final bool isExpanded;
  final ValueChanged<bool> onExpansionChanged;

  const ClipsAdvancedSettings({
    super.key,
    required this.controller,
    required this.isExpanded,
    required this.onExpansionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: const Text(
            'Advanced Settings',
            style: TextStyle(
              color: AppColors.text,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconColor: AppColors.text,
          collapsedIconColor: AppColors.text,
          initiallyExpanded: isExpanded,
          onExpansionChanged: onExpansionChanged,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ClipsWidgets.buildInlineNumberInputTile(
                    title: 'Encoder Speed',
                    subtitle: 'Speed/deadline (1-10)',
                    controller: controller.encoderSpeedController,
                  ),
                  ClipsWidgets.buildInlineNumberInputTile(
                    title: 'Buffer Duration',
                    subtitle: 'Seconds to buffer for clipping (5-300)',
                    controller: controller.bufferDurationController,
                  ),
                  ClipsWidgets.buildInlineNumberInputTile(
                    title: 'Segment Duration',
                    subtitle: 'Seconds per segment file (1-60)',
                    controller: controller.segmentDurationController,
                  ),
                  ClipsWidgets.buildPathInputTile(
                    title: 'Temp Directory',
                    subtitle: 'Custom temp directory (empty = system temp)',
                    controller: controller.tempDirController,
                    onBrowse: () => ClipsWidgets.pickDirectory(
                      controller.tempDirController,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
