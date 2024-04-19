import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:video_player_lilac/cores/widgets/spacer.dart';
import 'package:video_player_lilac/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:video_player_lilac/features/auth/services/firebase_methods.dart';

// ignore: must_be_immutable
class OtpPage extends StatelessWidget {
  final String vid;
  final String phone;
  OtpPage({super.key, required this.vid, required this.phone});

  static route(String vid, phone) => MaterialPageRoute(
        builder: (context) => OtpPage(
          vid: vid,
          phone: phone,
        ),
      );

  var code = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'OTP verification',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
              const SpacerWidget(
                height: 15,
              ),
              Text(
                'Enter OTP sent to $phone',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SpacerWidget(
                height: 30,
              ),
              Pinput(
                length: 6,
                onChanged: (value) {
                  code = value;
                },
              ),
              const SpacerWidget(
                height: 50,
              ),
              AuthGradientButton(
                  buttonText: 'Verify & Proceed',
                  onPressed: () {
                    context
                        .read<FirebaseAuthMethods>()
                        .signIn(vid, code, context);
                  }),
            ],
          )),
    );
  }
}
