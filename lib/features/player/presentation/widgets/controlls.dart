import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_lilac/features/auth/presentation/pages/login_page.dart';
import 'package:video_player_lilac/features/auth/services/firebase_methods.dart';
import 'package:video_player_lilac/features/player/presentation/provider/player_provider.dart';

List<Widget> playerControls(
    PlayerProvider provider, User? user, BuildContext context, key) {
  return [
    Positioned(
      top: 20,
      left: 0,
      child: IconButton(
        icon: const Icon(
          Icons.menu_outlined,
          color: Colors.white,
          size: 40,
        ),
        onPressed: () {
          key.currentState!.openDrawer();
        },
      ),
    ),
    Positioned(
      top: 30,
      right: 20,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade900,
        ),
        child: user != null
            ? InkWell(
                onTap: () => provider.showLogoutTileFunction(),
                child: SizedBox(
                    height: 40,
                    width: 40,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        context.read<FirebaseAuthMethods>().myUser.image!,
                      ),
                    )),
              )
            : IconButton.filled(
                onPressed: () {
                  provider.showLogoutTileFunction();
                },
                icon: const Icon(Icons.person),
              ),
      ),
    ),
    if (provider.showLogoutTile)
      Positioned(
        top: 80,
        right: 20,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade900,
          ),
          child: TextButton.icon(
            icon: user == null ? null : const Icon(Icons.logout),
            onPressed: () => user != null
                ? context.read<FirebaseAuthMethods>().signOut(context)
                : Navigator.push(context, LoginPage.route()),
            label: Text(
              user == null ? 'Sign In' : 'Logout',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    Positioned(
      bottom: 10,
      left: 0,
      child: IconButton(
        icon: Icon(
          provider.isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
          size: 50,
        ),
        onPressed: provider.togglePlay,
      ),
    ),
    Positioned(
      bottom: 50,
      left: 55,
      right: 85,
      child: VideoProgressIndicator(
        provider.controller,
        allowScrubbing: true,
        colors: const VideoProgressColors(
          playedColor: Color.fromARGB(135, 33, 243, 51),
          backgroundColor: Color.fromARGB(255, 74, 73, 73),
        ),
      ),
    ),
    Positioned(
      bottom: 44,
      right: 10,
      child: Text(
        '${provider.controller.value.position.inMinutes}:${provider.controller.value.position.inSeconds.remainder(60)} / ${provider.controller.value.duration.inMinutes}:${provider.controller.value.duration.inSeconds.remainder(60)}',
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    ),
    Positioned(
      bottom: 0,
      left: 55,
      child: Row(
        children: [
          GestureDetector(
            onDoubleTap: () => provider.toggleForwardPrevious('-'),
            onTap: () => provider.loadAndPlayNextVideo('previous'),
            child: const Icon(
              Icons.skip_previous,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 15),
          GestureDetector(
            onTap: () => provider.loadAndPlayNextVideo('next'),
            onDoubleTap: () => provider.toggleForwardPrevious('+'),
            child: const Icon(
              Icons.skip_next,
              color: Colors.white,
              size: 30,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.volume_up_rounded,
              color: Colors.white,
              size: 30,
            ),
            onPressed: provider.toggleVolume,
          ),
        ],
      ),
    ),
    Positioned(
      bottom: 0,
      right: -7,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              provider.isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              provider.isFullscreen = provider.isFullscreen;
              provider.toggleFullscreen();
            },
          ),
        ],
      ),
    ),
  ];
}
