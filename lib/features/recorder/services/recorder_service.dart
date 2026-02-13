// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import 'dart:io';
import '../../../core/logger.dart';

class RecorderService {
  static Process? _recordingProcess;

  static Future<int?> startStream() async {
    try {
      logger.i('Starting recording process...');
      _recordingProcess = await Process.start('wayland-recorder', [
        'record',
        '--clip-mode',
      ]);
      logger.i('Recording process started with PID: ${_recordingProcess!.pid}');
      return _recordingProcess!.pid;
    } catch (e, stack) {
      logger.e(
        'Failed to start recording process',
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  static void stopStream() {
    if (_recordingProcess != null) {
      logger.i(
        'Stopping recording process (PID: ${_recordingProcess!.pid})...',
      );
      _recordingProcess?.kill();
      _recordingProcess = null;
    }
  }
}
