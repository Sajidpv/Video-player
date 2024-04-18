import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_lilac/cores/utils/show_snackbar.dart';

class PlayerProvider with ChangeNotifier {
  late VideoPlayerController controller;
  late Future<void> initializeVideoPlayerFuture;
  bool showControls = true,
      isDarkMode = true,
      showLogoutTile = false,
      isFullscreen = false,
      isPlaying = true;
  Timer? hideControlsTimer;
  int currentVideoIndex = 0;
  PlayerProvider() {
    initState();
  }
  bool isLoading = false, isObscure = true, rememberMe = true;
  final List<Map<String, Object>> videoUrls = [
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

  void initState() {
    final url = videoUrls[currentVideoIndex]['videoUrl'] as String;
    controller = VideoPlayerController.networkUrl(
      Uri.parse(url),
    );
    initializeVideoPlayerFuture = controller.initialize();
    controller.setLooping(true);
    controller.play();
    hideControlsAfterDelay();
  }

  void hideControlsAfterDelay() {
    hideControlsTimer?.cancel();
    hideControlsTimer = Timer(const Duration(seconds: 5), () {
      showLogoutTile = false;
      showControls = false;
      notifyListeners();
    });
  }

  requestPermissions(context) async {
    var status = await Permission.videos.request();
    if (status.isGranted) {
      downloadVideo();
    } else {
      showSnackBar(context, 'Permission denied ');
    }
  }

  void toggleFullscreen() {
    if (isFullscreen) {
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

  Future<void> downloadVideo() async {
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

  void playVideo(String url) {
    controller = controller = VideoPlayerController.networkUrl(
      Uri.parse(url),
    );
    initializeVideoPlayerFuture = controller.initialize();
    controller.setLooping(true);
    controller.play();
    isPlaying = true;
    showControls = true;
    hideControlsAfterDelay();
    notifyListeners();
  }

  void toggleVolume() {
    if (controller.value.volume == 0.0) {
      controller.setVolume(1.0);
    } else {
      controller.setVolume(0.0);
    }
    notifyListeners();
  }

  void showLogoutTileFunction() {
    showLogoutTile = !showLogoutTile;
    notifyListeners();
  }

  void togglePlay() {
    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      controller.play();
    }
    isPlaying = controller.value.isPlaying;
    showControls = true;
    hideControlsAfterDelay();
    notifyListeners();
  }

  void toggleForwardPrevious(String operation) {
    if (operation == '+') {
      final currentPosition = controller.value.position;
      final newPosition = currentPosition + const Duration(seconds: 10);
      controller.seekTo(newPosition);
    } else {
      final currentPosition = controller.value.position;
      final newPosition = currentPosition - const Duration(seconds: 10);
      controller.seekTo(newPosition);
    }
    notifyListeners();
  }

  void loadAndPlayNextVideo(String mode) {
    if (currentVideoIndex < videoUrls.length - 1 && mode == 'next') {
      currentVideoIndex++;
    } else if (currentVideoIndex > 0 && mode == 'previous') {
      currentVideoIndex--;
    } else {
      return;
    }
    controller = VideoPlayerController.networkUrl(
        Uri.parse(videoUrls[currentVideoIndex]['videoUrl'] as String));
    initializeVideoPlayerFuture = controller.initialize();
    controller.play();

    isPlaying = true;
    showControls = true;
    hideControlsAfterDelay();
    notifyListeners();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    controller.dispose();
    hideControlsTimer?.cancel();
    super.dispose();
  }
}
