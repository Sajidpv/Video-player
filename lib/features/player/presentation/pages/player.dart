import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_lilac/features/auth/services/firebase_methods.dart';
import 'package:video_player_lilac/features/player/presentation/provider/player_provider.dart';
import 'package:video_player_lilac/features/player/presentation/widgets/controlls.dart';
import 'package:video_player_lilac/features/player/presentation/widgets/download_section.dart';
import 'package:video_player_lilac/features/player/presentation/widgets/drawer.dart';
import 'package:video_player_lilac/features/player/presentation/widgets/video_list.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});
  static route() =>
      MaterialPageRoute(builder: (context) => const VideoPlayerScreen());
  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    context.read<PlayerProvider>();

    final user = context.watch<User?>();
    if (user != null) context.read<FirebaseAuthMethods>().getUserProfile();
    return Consumer<PlayerProvider>(builder: (context, provider, child) {
      return GestureDetector(
        onTap: () {
          setState(() {
            provider.showControls = !provider.showControls;
            if (!provider.showControls) provider.showLogoutTile = false;
          });
          context.read<PlayerProvider>().hideControlsAfterDelay();
        },
        child: SafeArea(
          child: Scaffold(
            key: scaffoldKey,
            drawer: PlayerDrawer(user: user),
            body: Column(
              children: [
                Column(
                  children: [
                    FutureBuilder(
                      future: provider.initializeVideoPlayerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Stack(
                            children: [
                              AspectRatio(
                                aspectRatio:
                                    provider.controller.value.aspectRatio,
                                child: VideoPlayer(provider.controller),
                              ),
                              if (provider.showControls)
                                ...playerControls(
                                    provider, user, context, scaffoldKey),
                            ],
                          );
                        } else {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height / 3.5,
                            child: AspectRatio(
                              aspectRatio:
                                  provider.controller.value.aspectRatio,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    DownloadSection(
                      provider: provider,
                    )
                  ],
                ),
                VideoList(
                  provider: provider,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
