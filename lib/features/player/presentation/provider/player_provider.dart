import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
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
      isPlaying = true,
      isMuted = false,
      isDownloadComplete = false,
      isVideoLocal = false;
  Timer? hideControlsTimer;
  int currentVideoIndex = 0;
  late encrypt.Key key;
  final iv = encrypt.IV.fromLength(16);
  PlayerProvider() {
    key = generateRandomKey();
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

  void initState() async {
    final url = videoUrls[currentVideoIndex]['videoUrl'] as String;
    controller = VideoPlayerController.networkUrl(
      Uri.parse(url),
    );
    initializeVideoPlayerFuture = controller.initialize();
    isSetLocal();
    controller.setLooping(true);
    controller.play();
    hideControlsAfterDelay();
  }

  Future isSetLocal() async {
    bool videoExists = await checkVideoExistsLocally();
    if (videoExists) {
      isVideoLocal = true;
      notifyListeners();

      return;
      // await decryptAndPlayVideo();
    } else {
      isVideoLocal = false;
      notifyListeners();
    }
  }

  Future<bool> checkVideoExistsLocally() async {
    String? videoPath = await getLocalVideoPath();
    if (videoPath != null) {
      File videoFile = File(videoPath);
      return videoFile.exists();
    } else {
      return false;
    }
  }

  Future<void> decryptAndPlayVideo() async {
    String? videoPath = await getLocalVideoPath();
    if (videoPath != null) {
      File encryptedVideoFile = File(videoPath);

      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      Uint8List encryptedBytes = await encryptedVideoFile.readAsBytes();
      List<int> decryptedBytes =
          encrypter.decryptBytes(encrypt.Encrypted(encryptedBytes), iv: iv);

      File decryptedVideoFile =
          await createTemporaryDecryptedVideoFile(decryptedBytes);

      controller = VideoPlayerController.asset(
        'file://${decryptedVideoFile.path}',
      );
    } else {
      return;
    }
  }

  encrypt.Key generateRandomKey() {
    final random = Random.secure();
    Uint8List keyBytes =
        Uint8List.fromList(List.generate(32, (_) => random.nextInt(256)));
    return encrypt.Key(keyBytes);
  }

  Future<String?> getLocalVideoPath() async {
    Directory? appDocDir = await getDownloadsDirectory();
    if (appDocDir == null) return null;
    String fileName = '${controller.dataSource.split('/').last}';

    List<FileSystemEntity> files = appDocDir.listSync();
    for (FileSystemEntity file in files) {
      if (file is File && file.path.endsWith(fileName)) {
        isVideoLocal = true;
        notifyListeners();
        return file.path;
      } else {
        isVideoLocal = false;
        notifyListeners();
        return null;
      }
    }

    return null;
  }

  Future<File> createTemporaryDecryptedVideoFile(List<int> bytes) async {
    Directory tempDir = await getTemporaryDirectory();
    String fileName = '${controller.dataSource.split('/').last}';
    File tempFile = File('${tempDir.path}/$fileName');
    await tempFile.writeAsBytes(bytes, flush: true);
    return tempFile;
  }

  Future<void> downloadAndSaveVideo(context) async {
    showSnackBar(context, 'Downloading started.');
    final path = await getDownloadsDirectory();
    String fileName = '${controller.dataSource.split('/').last}';
    await FlutterDownloader.enqueue(
      url: controller.dataSource,
      savedDir: path!.path,
      fileName: fileName,
      showNotification: true,
      openFileFromNotification: true,
    );
    if (DownloadTaskStatus.complete.index == 100) {
      showSnackBar(context, '$fileName downloading completed');
      //encryptAndSaveDownloadedVideo(path.path, fileName);
    }
  }

  Future<void> encryptAndSaveDownloadedVideo(
      String savedDir, String fileName) async {
    if (!isDownloadComplete) {
      return;
    }
    File videoFile = File('$savedDir/$fileName');
    Uint8List videoBytes = await videoFile.readAsBytes();
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    List<int> encryptedBytes = encrypter.encryptBytes(videoBytes).bytes;
    File encryptedVideoFile = File('$savedDir/${fileName}_encrypted');
    await encryptedVideoFile.writeAsBytes(encryptedBytes);
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
      await downloadAndSaveVideo(context);
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

  void playVideo(String url, context) async {
    controller = VideoPlayerController.networkUrl(
      Uri.parse(url),
    );
    await isSetLocal();
    String? videoPath = await getLocalVideoPath();
    print(isVideoLocal);
    if (isVideoLocal == true && videoPath != null) {
      File videoFile = File(videoPath);
      controller = VideoPlayerController.file(videoFile);
      showSnackBar(context, 'Palying from local storage');
    } else {
      controller = VideoPlayerController.networkUrl(
        Uri.parse(url),
      );
      showSnackBar(context, 'Palying from Online');
    }

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
      isMuted = false;
      controller.setVolume(1.0);
    } else {
      isMuted = true;
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

  void toggleForwardPrevious(String operation) async {
    await isSetLocal();
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

  void loadAndPlayNextVideo(String mode) async {
    await isSetLocal();
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
