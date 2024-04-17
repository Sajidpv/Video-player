import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:video_player_lilac/cores/utils/show_snackbar.dart';
import 'package:video_player_lilac/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:video_player_lilac/features/player/presentation/pages/player.dart';

class OtpPage extends StatefulWidget {
  final String vid;
  const OtpPage({super.key, required this.vid});

  static route(String vid) => MaterialPageRoute(
        builder: (context) => OtpPage(
          vid: vid,
        ),
      );

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _firebase = FirebaseAuth.instance;
  void signIn() async {
    PhoneAuthCredential credential =
        PhoneAuthProvider.credential(verificationId: widget.vid, smsCode: code);
    try {
      await _firebase.signInWithCredential(credential).then((value) =>
          Navigator.pushReplacement(context, VideoPlayerScreen.route()));
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.code);
    } catch (e) {
      showSnackBar(context, 'Error Occured${e.toString()}');
    }
  }

  var code = '';
  final otpController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'OTP verification',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'Enter OTP sent to +919539662196',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Pinput(
                  length: 6,
                  onChanged: (value) {
                    setState(() {
                      code = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
                AuthGradientButton(
                    buttonText: 'Verify & Proceed',
                    onPressed: () {
                      signIn();
                    }),
              ],
            ),
          )),
    );
  }
}
