import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;

class VideosPage extends StatelessWidget {
  Future<List<File>> getVideos() async {
    final config = Directory(
      '${Platform.environment['HOME']}/.config/wayland-recorder/settings.json',
    );

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
        Logger.root.info('Thumbnail saved to $thumbnailPath');
        return File(thumbnailPath);
      } else {
        Logger.root.severe('Error generating thumbnail: ${result.stderr}');
        return null;
      }
    } catch (e) {
      Logger.root.severe('Failed to generate thumbnail for $videoPath: $e');
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

  const VideosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<File>>(
      future: gatherVideoThumbnails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No videos yet'));
        } else {
          final thumbnails = snapshot.data!;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: thumbnails.length,
            itemBuilder: (context, index) {
              return Image.file(thumbnails[index]);
            },
          );
        }
      },
    );
  }
}
