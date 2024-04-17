import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_lilac/cores/theme/bloc/theme_bloc.dart';
import 'package:video_player_lilac/cores/utils/show_snackbar.dart';
import 'package:video_player_lilac/cores/widgets/buttons.dart';
import 'package:video_player_lilac/features/auth/presentation/pages/login_page.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});
  static route() =>
      MaterialPageRoute(builder: (context) => const VideoPlayerScreen());
  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  final user = FirebaseAuth.instance.currentUser;
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _showControls = true,
      isDarkMode = true,
      _showLogoutTile = false,
      _isFullscreen = false,
      _isPlaying = false;
  Timer? _hideControlsTimer;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentVideoIndex = 0;
  final List<Map<String, Object>> _videoUrls = [
    {
      'id': "1",
      'name': "For Bigger Joyrides",
      'videoUrl':
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
      'thumbnailUrl':
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerJoyrides.jpg",
    },
    {
      'id': "2",
      'name': "Elephant Dream",
      'videoUrl':
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
      'thumbnailUrl':
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ElephantsDream.jpg",
    },
    {
      'id': "3",
      'name': "Big Buck Bunny",
      'videoUrl':
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
      'thumbnailUrl':
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg",
    },
    {
      'id': "4",
      'name': "For Bigger Blazes",
      'videoUrl':
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
      'thumbnailUrl':
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerBlazes.jpg"
    },
    {
      'id': "5",
      'name': "Butterfly",
      'videoUrl':
          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      'thumbnailUrl': ''
    },
    {
      'id': "6",
      'name': "For Bigger Escape",
      'videoUrl':
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
      'thumbnailUrl':
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerEscapes.jpg"
    },
    {
      'id': "7",
      'name': "Bee",
      'videoUrl':
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      'thumbnailUrl': ''
    },
    {
      'id': "8",
      'name': "For Bigger Fun",
      'videoUrl':
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
      'thumbnailUrl':
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerFun.jpg"
    }
  ];

  @override
  void initState() {
    super.initState();
    final url = _videoUrls[_currentVideoIndex]['videoUrl'] as String;
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(url),
    );

    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _hideControlsAfterDelay();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _controller.dispose();
    _hideControlsTimer?.cancel();
    super.dispose();
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  _requestPermissions() async {
    var status = await Permission.videos.request();
    if (status.isGranted) {
      _downloadVideo();
    } else {
      showSnackBar(context, 'Permission denied ');
    }
  }

  void _toggleFullscreen() {
    if (_isFullscreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }
  //  Future<void> _downloadVideo() async {
  //   String path = '';
  //   if (path.isEmpty) {
  //     path = await FilePicker.platform.getDirectoryPath() ?? '';
  //   }
  //   if (path.isNotEmpty) {
  //     String fileName =
  //         '${DateTime.now().microsecond}${_controller.dataSource.split('/').last}';
  //     String savePath = '$path/$fileName';
  //     print('this is file path : $savePath');
  //     try {
  //       final taskId = await FlutterDownloader.enqueue(
  //         url: _controller.dataSource,
  //         savedDir: path,
  //         fileName: fileName,
  //         showNotification: true,
  //         openFileFromNotification: true,
  //       );

  //       // Encrypted file path
  //       String encryptedFilePath = await _encryptFile(savePath);

  //       showSnackBar(context, 'Download started: $fileName');
  //     } catch (e) {
  //       print('this is error :${e.toString()}');
  //     }
  //   }
  // }

  // Future<String> _encryptFile(String filePath) async {
  //   // Read file content
  //   File file = File(filePath);
  //   List<int> fileBytes = await file.readAsBytes();
  //   var sha256 = sha256.convert(fileBytes);
  //   String encryptedFilePath = filePath.replaceAll(
  //       '.mp4', '_encrypted.mp4'); // Change file extension as needed
  //   File encryptedFile = File(encryptedFilePath);
  //   await encryptedFile.writeAsBytes(
  //       sha256.bytes); // Example: Write encrypted content to a new file

  //   return encryptedFilePath;
  // }

  // Future<bool> _isFileAvailableOffline(String filePath) async {
  //   // Check if the encrypted file exists locally
  //   return File(filePath).exists();
  // }

  // void _playVideo(String url) async {
  //   String offlineFilePath = ''; // Path to the encrypted file
  //   bool isAvailableOffline = await _isFileAvailableOffline(offlineFilePath);
  //   final VideoPlayerController videoFile;
  //   isAvailableOffline
  //       ? {videoFile = VideoPlayerController.asset(offlineFilePath)}
  //       : videoFile = VideoPlayerController.networkUrl(
  //           Uri.parse(url),
  //         );

  //   setState(() {
  //     _controller = videoFile;
  //     _initializeVideoPlayerFuture = _controller.initialize();
  //     _controller.setLooping(true);
  //     _controller.play();
  //     _isPlaying = true;
  //     _showControls = true;
  //     _hideControlsAfterDelay();
  //   });
  // }

  Future<void> _downloadVideo() async {
    // String path = '';
    // if (path.isEmpty) {
    //   path = await FilePicker.platform.getDirectoryPath() ?? '';
    // }
    // if (path.isNotEmpty) {
    //   String fileName =
    //       '${DateTime.now().microsecond}${_controller.dataSource.split('/').last}';
    //   String savePath = '$path/$fileName';
    //   print('this is file path : $savePath');
    //   try {
    //     final taskId = await FlutterDownloader.enqueue(
    //       url: _controller.dataSource,
    //       savedDir: path,
    //       fileName: fileName,
    //       showNotification: true,
    //       openFileFromNotification: true,
    //     );
    //     showSnackBar(context, 'Download started: $fileName');
    //   } catch (e) {
    //     print('this is error :${e.toString()}');
    //   }
    // }
  }

  void _playVideo(String url) {
    setState(() {
      _controller = _controller = VideoPlayerController.networkUrl(
        Uri.parse(url),
      );
      _initializeVideoPlayerFuture = _controller.initialize();
      _controller.setLooping(true);
      _controller.play();
      _isPlaying = true;
      _showControls = true;
      _hideControlsAfterDelay();
    });
  }

  void _toggleVolume() {
    setState(() {
      if (_controller.value.volume == 0.0) {
        _controller.setVolume(1.0);
      } else {
        _controller.setVolume(0.0);
      }
    });
  }

  void _togglePlay() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      _isPlaying = _controller.value.isPlaying;
      _showControls = true;
      _hideControlsAfterDelay();
    });
  }

  void _toggleForwardPrevious(String operation) {
    setState(() {
      if (operation == '+') {
        final currentPosition = _controller.value.position;
        final newPosition = currentPosition + const Duration(seconds: 2);
        _controller.seekTo(newPosition);
      } else {
        final currentPosition = _controller.value.position;
        final newPosition = currentPosition - const Duration(seconds: 2);
        _controller.seekTo(newPosition);
      }
    });
  }

  void _loadAndPlayNextVideo(String mode) {
    if (_currentVideoIndex < _videoUrls.length - 1 && mode == 'next') {
      _currentVideoIndex++;
    } else if (_currentVideoIndex > 0 && mode == 'previous') {
      _currentVideoIndex--;
    } else {
      return;
    }
    _controller = VideoPlayerController.networkUrl(
        Uri.parse(_videoUrls[_currentVideoIndex]['videoUrl'] as String));
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.play();
    setState(() {
      _isPlaying = true;
      _showControls = true;
      _hideControlsAfterDelay();
    });
  }

  void _hideControlsAfterDelay() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 5), () {
      setState(() {
        _showControls = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showControls = !_showControls;
        });
        _hideControlsAfterDelay();
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              ListTile(
                tileColor: Theme.of(context).primaryColor,
                visualDensity: const VisualDensity(vertical: -3, horizontal: 1),
                title: Text(user != null ? user!.uid : 'Signin/Register'),
                onTap: () {
                  user != null
                      ? null
                      : Navigator.push(context, LoginPage.route());
                  // Navigator.pop(context);
                },
              ),
              ListTile(
                tileColor: Theme.of(context).primaryColor,
                visualDensity: const VisualDensity(vertical: -3, horizontal: 1),
                title: const Text('Profile'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                tileColor: Theme.of(context).primaryColor,
                visualDensity: const VisualDensity(vertical: -3, horizontal: 1),
                trailing: BlocBuilder<ThemeBloc, ThemeState>(
                  builder: (context, state) {
                    return Switch(
                      value: context.read<ThemeBloc>().darkTheme,
                      onChanged: (value) {
                        context.read<ThemeBloc>().add(ThemeChangedEvent());
                      },
                    );
                  },
                ),
                title: const Text('Dark Mode '),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Column(
              children: [
                FutureBuilder(
                  future: _initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Stack(
                        children: [
                          AspectRatio(
                            aspectRatio: _isFullscreen
                                ? 20
                                : _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          ),
                          if (_showControls) ...[
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
                                    _scaffoldKey.currentState!.openDrawer();
                                  }),
                            ),
                            Positioned(
                              top: 30,
                              right: 20,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade900,
                                ),
                                child: IconButton.filled(
                                  onPressed: () {
                                    setState(() {
                                      user != null
                                          ? _showLogoutTile = !_showLogoutTile
                                          : null;
                                    });
                                  },
                                  icon: const Icon(Icons.person),
                                ),
                              ),
                            ),
                            if (_showLogoutTile)
                              Positioned(
                                top: 80,
                                right: 20,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.shade900,
                                  ),
                                  child: TextButton.icon(
                                    icon: const Icon(Icons.logout),
                                    onPressed: (() => signOut()),
                                    label: const Text(
                                      'Logout',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            Positioned(
                              bottom: 10,
                              left: 0,
                              child: IconButton(
                                icon: Icon(
                                  _isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 50,
                                ),
                                onPressed: _togglePlay,
                              ),
                            ),
                            Positioned(
                              bottom: 50,
                              left: 55,
                              right: 85,
                              child: VideoProgressIndicator(
                                _controller,
                                allowScrubbing: true,
                                colors: const VideoProgressColors(
                                  playedColor: Color.fromARGB(135, 33, 243, 51),
                                  backgroundColor:
                                      Color.fromARGB(255, 74, 73, 73),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 44,
                              right: 10,
                              child: Text(
                                '${_controller.value.position.inMinutes}:${_controller.value.position.inSeconds.remainder(60)} / ${_controller.value.duration.inMinutes}:${_controller.value.duration.inSeconds.remainder(60)}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 55,
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.skip_previous,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      _toggleForwardPrevious('-');
                                    },
                                  ),
                                  IconButton(
                                      icon: const Icon(
                                        Icons.skip_next,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        _toggleForwardPrevious('+');
                                      }),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.volume_up_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      _toggleVolume();
                                    },
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
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      // Implement logic for settings button
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      _isFullscreen
                                          ? Icons.fullscreen_exit
                                          : Icons.fullscreen,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isFullscreen = _isFullscreen;
                                        _toggleFullscreen();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      );
                    } else {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height / 3.5,
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      );
                    }
                  },
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.grey.shade200),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customButtons(context, Icons.arrow_back_ios_outlined,
                          onClick: () {
                        _loadAndPlayNextVideo('previous');
                      }),
                      PrimaryButton(
                        label: 'Download',
                        onPressed: () async {
                          await _requestPermissions();
                        },
                        icon: Icons.arrow_drop_down_rounded,
                      ),
                      customButtons(context, Icons.arrow_forward_ios_outlined,
                          onClick: () {
                        _loadAndPlayNextVideo('next');
                      }),
                    ],
                  ),
                )
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _videoUrls.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentVideoIndex = index;
                      });
                      _playVideo(_videoUrls[index]['videoUrl'] as String);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ListTile(
                        tileColor: Colors.primaries.last,
                        leading: SizedBox(
                          width: 40,
                          height: 30,
                          child: _videoUrls[index]['thumbnailUrl'] == ''
                              ? const Placeholder()
                              : Image.network(
                                  _videoUrls[index]['thumbnailUrl'] as String),
                        ),
                        title: Text(
                          _videoUrls[index]['name'] as String,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
