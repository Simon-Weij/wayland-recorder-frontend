// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import 'dart:convert';
import 'dart:io';
import '../../../../../core/logger.dart';
import 'package:path/path.dart' as path;

class VideosService {
  Future<List<File>> getVideos() async {
    final config = Directory(
      '${Platform.environment['HOME']}/.config/wayland-recorder/settings.json',
    );

    if (!config.existsSync()) {
      return [];
    }

    final file = File(config.path);
    final jsonString = await file.readAsString();

    final Map<String, dynamic> jsonData = jsonDecode(jsonString);

    final videosPath = jsonData["outputPath"] as String;

    final List<File> videos = [];

    final entities = await Directory(videosPath).list().toList();
    for (final entity in entities) {
      if (entity is File &&
          (entity.path.endsWith('.mp4') || entity.path.endsWith('.webm'))) {
        videos.add(entity);
      }
    }
    return videos;
  }

  Future<File?> generateThumbnail(String videoPath, Directory tempDir) async {
    try {
      final videoFileName = path.basenameWithoutExtension(videoPath);
      final thumbnailPath = path.join(
        tempDir.path,
        '${videoFileName}_thumb.png',
      );

      final result = await Process.run('ffmpeg', [
        '-i',
        videoPath,
        '-ss',
        '00:00:05',
        '-vframes',
        '1',
        thumbnailPath,
      ]);

      if (result.exitCode == 0 && File(thumbnailPath).existsSync()) {
        logger.i('Thumbnail saved to $thumbnailPath');
        return File(thumbnailPath);
      } else {
        logger.e('Error generating thumbnail: ${result.stderr}');
        return null;
      }
    } catch (e) {
      logger.e('Failed to generate thumbnail for $videoPath: $e');
      return null;
    }
  }

  Future<List<File>> gatherVideoThumbnails() async {
    final videos = await getVideos();
    final thumbnailFiles = <File>[];
    final tempDir = await Directory.systemTemp.createTemp('video_thumbnails');

    for (final video in videos) {
      final thumbnail = await generateThumbnail(video.path, tempDir);
      if (thumbnail != null) {
        thumbnailFiles.add(thumbnail);
      }
    }

    return thumbnailFiles;
  }
}
