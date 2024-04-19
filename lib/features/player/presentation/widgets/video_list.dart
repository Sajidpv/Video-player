import 'package:flutter/material.dart';
import 'package:video_player_lilac/features/player/presentation/provider/player_provider.dart';

class VideoList extends StatelessWidget {
  const VideoList({
    super.key,
    required this.provider,
  });
  final PlayerProvider provider;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(Duration(seconds: 2));
        },
        child: ListView.builder(
          itemCount: provider.videoUrls.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                provider.currentVideoIndex = index;
                provider.playVideo(
                    provider.videoUrls[index]['videoUrl'] as String, context);
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  child: ListTile(
                    tileColor: Colors.primaries.last,
                    leading: SizedBox(
                      width: 40,
                      height: 30,
                      child: provider.videoUrls[index]['thumbnailUrl'] == ''
                          ? const Placeholder()
                          : Image.network(provider.videoUrls[index]
                              ['thumbnailUrl'] as String),
                    ),
                    title: Text(
                      provider.videoUrls[index]['name'] as String,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
