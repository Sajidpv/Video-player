import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:video_player_lilac/cores/utils/show_snackbar.dart';
import 'package:video_player_lilac/features/auth/data/model/user_model.dart';
import 'package:video_player_lilac/features/auth/presentation/pages/otp_page.dart';
import 'package:video_player_lilac/features/auth/presentation/pages/profile_page.dart';

class FirebaseAuthMethods {
  final phoneController = TextEditingController();
  final pinController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuthMethods(this._auth);
  // GET USER DATA
  User get user => _auth.currentUser!;

  // STATE PERSISTENCE STREAM
  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();

  // PHONE SIGN IN
  Future<void> signInWithPhoneNumber(
    BuildContext context,
  ) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: '+91${phoneController.text.trim()}',
        verificationCompleted: (PhoneAuthCredential credential) {
          // pinController.setText(credential.smsCode);
        },
        verificationFailed: (FirebaseAuthException e) {
          showSnackBar(context, e.code);
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.pushReplacement(
              context,
              OtpPage.route(
                  verificationId, '+91${phoneController.text.trim()}'));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      if (context.mounted) showSnackBar(context, 'Error Occured${e.code}');
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, 'Error Occured${e.toString()}');
      }
    }
  }

  Future<void> signIn(String vid, String code, BuildContext context) async {
    PhoneAuthCredential credential =
        PhoneAuthProvider.credential(verificationId: vid, smsCode: code);
    try {
      await _auth.signInWithCredential(credential).then(
          (value) => Navigator.pushReplacement(context, ProfilePage.route()));
    } on FirebaseAuthException catch (e) {
      String error = e.code;
      if (e.code == 'channel-error') {
        error = 'Invalid OTP';
      }
      if (context.mounted) {
        showSnackBar(context, error);
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, 'Error Occured${e.toString()}');
      }
    }
  }

  // SIGN OUT
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.message!);
      }
    }
  }

  //UPLOAD IMAGE
  Future<String> uploadImageToStorage(String childName, Uint8List file) async {
    Reference ref = _storage.ref().child(childName);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  //SET PROFILE
  Future<String> saveData({
    required String name,
    required String email,
    required String dob,
    required Uint8List file,
  }) async {
    String resp = "Error Occurred";
    User? user = _auth.currentUser;
    try {
      if (name.isNotEmpty &&
          email.isNotEmpty &&
          dob.isNotEmpty &&
          file.isNotEmpty &&
          user != null) {
        String imageUrl = await uploadImageToStorage('profileImage', file);

        DocumentReference userDocRef =
            _firestore.collection('userProfile').doc(user.uid);

        await userDocRef.set({
          'name': name,
          'email': email,
          'dob': dob,
          'imageLink': imageUrl,
        });

        resp = 'success';
      }
    } catch (err) {
      resp = err.toString();
    }
    return resp;
  }

  var myUser = UserModel();
  //FETCH USER PROFILE
  Future getUserProfile() async {
    String uid = _auth.currentUser!.uid;
    try {
      _firestore.collection('userProfile').doc(uid).snapshots().listen((event) {
        myUser = UserModel.fromJson(event.data()!);
      });
    } on FirebaseException catch (e) {
      print(e);
    }
  }
}
