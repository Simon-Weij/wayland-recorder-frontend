import 'dart:io';

class Stream {
  static Process? _recordingProcess;

  static Future<int?> startStream() async {
    _recordingProcess = await Process.start('wayland-recorder', [
      'record',
      '--clip-mode',
    ]);

    return _recordingProcess!.pid;
  }

  static void stopStream() {
    _recordingProcess?.kill();
    _recordingProcess = null;
  }
}
