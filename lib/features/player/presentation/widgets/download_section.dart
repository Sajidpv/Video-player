import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player_lilac/cores/theme/color_pellets.dart';
import 'package:video_player_lilac/cores/theme/provider/theme_provider.dart';
import 'package:video_player_lilac/cores/utils/show_snackbar.dart';
import 'package:video_player_lilac/cores/widgets/buttons.dart';
import 'package:video_player_lilac/features/auth/presentation/pages/login_page.dart';
import 'package:video_player_lilac/features/player/presentation/provider/player_provider.dart';

class DownloadSection extends StatelessWidget {
  const DownloadSection({
    super.key,
    required this.provider,
    this.user,
  });
  final PlayerProvider provider;
  final user;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: context.read<ThemeProvider>().val
              ? const Color.fromARGB(106, 98, 98, 116)
              : AppPallete.greyColor),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          customButtons(context, Icons.arrow_back_ios_outlined, onClick: () {
            provider.loadAndPlayNextVideo('previous');
          }),
          Consumer<PlayerProvider>(builder: (context, provider, child) {
            return PrimaryButton(
              label: '  Download',
              onPressed: () async {
                if (user == null) {
                  Navigator.push(context, LoginPage.route());
                  showSnackBar(context, 'Login to download');
                } else {
                  await provider.isSetLocal();
                  if (!provider.isVideoLocal) {
                    print('not local');
                    await provider.requestPermissions(context);
                  } else {
                    showSnackBar(context, 'Already downloaded');
                  }
                }
              },
              icon: provider.isVideoLocal ? Icons.done : Icons.download,
            );
          }),
          customButtons(context, Icons.arrow_forward_ios_outlined, onClick: () {
            provider.loadAndPlayNextVideo('next');
          }),
        ],
      ),
    );
  }
}
