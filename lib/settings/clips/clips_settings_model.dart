// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

class ClipsSettings {
  String cursorMode;
  String outputPath;
  String codec;
  String container;
  int encoderSpeed;
  int quality;
  bool audioMonitor;
  bool audioMic;
  int bufferDuration;
  int segmentDuration;
  String tempDir;
  String hotkey;

  ClipsSettings({
    this.cursorMode = 'embedded',
    this.outputPath = '',
    this.codec = 'h264',
    this.container = 'mp4',
    this.encoderSpeed = 6,
    this.quality = 5000000,
    this.audioMonitor = true,
    this.audioMic = true,
    this.bufferDuration = 30,
    this.segmentDuration = 5,
    this.tempDir = '',
    this.hotkey = '',
  });

  factory ClipsSettings.fromJson(Map<String, dynamic> json) {
    return ClipsSettings(
      cursorMode: json['cursorMode'] ?? 'embedded',
      outputPath: json['outputPath'] ?? '',
      codec: json['codec'] ?? 'h264',
      container: json['container'] ?? 'mp4',
      encoderSpeed: json['encoderSpeed'] ?? 6,
      quality: json['quality'] ?? 5000000,
      audioMonitor: json['audioMonitor'] ?? true,
      audioMic: json['audioMic'] ?? true,
      bufferDuration: json['bufferDuration'] ?? 30,
      segmentDuration: json['segmentDuration'] ?? 5,
      tempDir: json['tempDir'] ?? '',
      hotkey: json['hotkey'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cursorMode': cursorMode,
      'outputPath': outputPath,
      'codec': codec,
      'container': container,
      'encoderSpeed': encoderSpeed,
      'quality': quality,
      'audioMonitor': audioMonitor,
      'audioMic': audioMic,
      'bufferDuration': bufferDuration,
      'segmentDuration': segmentDuration,
      'tempDir': tempDir,
      'hotkey': hotkey,
    };
  }
}
