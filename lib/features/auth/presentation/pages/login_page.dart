import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video_player_lilac/cores/utils/show_snackbar.dart';
import 'package:video_player_lilac/features/auth/presentation/pages/otp_page.dart';
import 'package:video_player_lilac/features/auth/presentation/widgets/auth_field.dart';
import 'package:video_player_lilac/features/auth/presentation/widgets/auth_gradient_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static route() => MaterialPageRoute(
        builder: (context) => const LoginPage(),
      );

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _firebase = FirebaseAuth.instance;
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    phoneController.dispose();
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
                  'Your Phone !',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  textAlign: TextAlign.center,
                  'We will send you an one time password on this mobile number',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                AuthField(
                    prefix: '+91 ',
                    hintText: 'Phone',
                    input: TextInputType.phone,
                    controller: phoneController),
                const SizedBox(
                  height: 40,
                ),
                AuthGradientButton(
                    buttonText: 'Get Otp',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        signInWithPhoneNumber(phoneController.text.trim());
                      }
                    }),
              ],
            ),
          )),
    );
  }

  Future<void> signInWithPhoneNumber(String phoneNumber) async {
    try {
      await _firebase.verifyPhoneNumber(
        phoneNumber: '+91$phoneNumber',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          showSnackBar(context, e.code);
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.push(context, OtpPage.route(verificationId));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, 'Error Occured${e.code}');
    } catch (e) {
      showSnackBar(context, 'Error Occured${e.toString()}');
    }
  }
}
