import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player_lilac/cores/widgets/spacer.dart';
import 'package:video_player_lilac/features/auth/presentation/widgets/auth_field.dart';
import 'package:video_player_lilac/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:video_player_lilac/features/auth/services/firebase_methods.dart';
import 'package:video_player_lilac/features/player/presentation/pages/player.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static route() => MaterialPageRoute(
        builder: (context) => const LoginPage(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () =>
                  Navigator.pushReplacement(context, VideoPlayerScreen.route()),
              child: const Text('Guest user')),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: context.read<FirebaseAuthMethods>().formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Your Phone !',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
                const SpacerWidget(
                  height: 15,
                ),
                const Text(
                  textAlign: TextAlign.center,
                  'We will send you an one time password on this mobile number',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SpacerWidget(
                  height: 30,
                ),
                AuthField(
                    prefix: '+91 ',
                    hintText: 'Phone',
                    input: TextInputType.phone,
                    controller:
                        context.read<FirebaseAuthMethods>().phoneController),
                const SpacerWidget(
                  height: 40,
                ),
                AuthGradientButton(
                    buttonText: 'Get Otp',
                    onPressed: () {
                      if (context
                          .read<FirebaseAuthMethods>()
                          .formKey
                          .currentState!
                          .validate()) {
                        context
                            .read<FirebaseAuthMethods>()
                            .signInWithPhoneNumber(context);
                      }
                    }),
              ],
            ),
          )),
    );
  }
}
