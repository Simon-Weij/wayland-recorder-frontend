// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import 'dart:io';
import 'package:flutter/material.dart';
import 'services/videos_service.dart';

class VideosPage extends StatelessWidget {
  final VideosService _videosService = VideosService();

  VideosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<File>>(
      future: _videosService.gatherVideoThumbnails(),
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
