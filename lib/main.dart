import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:video_player_lilac/cores/theme/bloc/theme_bloc.dart';
import 'package:video_player_lilac/cores/theme/theme.dart';
import 'package:video_player_lilac/features/player/presentation/pages/player.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterDownloader.initialize();
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    if (Platform.isAndroid) {
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    }
  });
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => ThemeBloc(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Video Player',
          theme: context.read<ThemeBloc>().darkTheme
              ? AppTheme.darkThemeMode
              : AppTheme.lightThemeMode,
          home: const VideoPlayerScreen(),
        );
      },
    );
  }
}
