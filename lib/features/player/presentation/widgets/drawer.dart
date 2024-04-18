import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:video_player_lilac/cores/theme/color_pellets.dart';
import 'package:video_player_lilac/cores/theme/provider/theme_provider.dart';
import 'package:video_player_lilac/cores/widgets/spacer.dart';
import 'package:video_player_lilac/features/auth/presentation/pages/login_page.dart';
import 'package:video_player_lilac/features/auth/presentation/pages/profile_page.dart';
import 'package:video_player_lilac/features/auth/services/firebase_methods.dart';

class PlayerDrawer extends StatelessWidget {
  const PlayerDrawer({
    super.key,
    required this.user,
  });

  final User? user;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SpacerWidget(
            height: 20,
          ),
          const SizedBox(
            child: ListTile(
                title: Text(
              'L Player',
              style: TextStyle(
                  fontSize: 25, fontWeight: FontWeight.bold, letterSpacing: 5),
              textAlign: TextAlign.center,
            )),
          ),
          Container(
            height: 2,
            width: 200,
            color: AppPallete.greyColor,
          ),
          const SpacerWidget(
            height: 20,
          ),
          ListTile(
            leading: const Icon(Icons.login),
            visualDensity: const VisualDensity(vertical: -3, horizontal: 1),
            title: Text(user != null
                ? context.read<FirebaseAuthMethods>().myUser.name!
                : 'Signin/Register'),
            onTap: () {
              user != null ? null : Navigator.push(context, LoginPage.route());
              // Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            visualDensity: const VisualDensity(vertical: -3, horizontal: 1),
            title: const Text('Profile'),
            onTap: () {
              user == null
                  ? Navigator.push(context, LoginPage.route())
                  : Navigator.push(
                      context,
                      ProfilePage.route(
                          user: context.read<FirebaseAuthMethods>().myUser));
            },
          ),
          ListTile(
            leading: const Icon(Icons.color_lens),
            visualDensity: const VisualDensity(vertical: -3, horizontal: 1),
            trailing:
                Consumer<ThemeProvider>(builder: (context, provider, child) {
              return Switch(
                value: provider.val,
                onChanged: (value) {
                  provider.toggleTheme();
                },
              );
            }),
            title: const Text('Dark Mode '),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          user == null
              ? const SizedBox()
              : ListTile(
                  leading: const Icon(Icons.logout),
                  visualDensity:
                      const VisualDensity(vertical: -3, horizontal: 1),
                  title: const Text('Logout'),
                  onTap: () {
                    context.read<FirebaseAuthMethods>().signOut(context);
                  },
                ),
        ],
      ),
    );
  }
}
