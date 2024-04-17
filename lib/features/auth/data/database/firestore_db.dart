import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DataBase {
  static Future updateProfile(
      Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('user')
        .doc(id)
        .set(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getUserInfo() async {
    return await FirebaseFirestore.instance.collection('user').snapshots();
  }

  static Future<String> uploadImageToFirebaseStorage(String imagePath) async {
    String imageUrl = '';
    try {
      // Create a reference to the location you want to upload to in Firebase Storage
      final ref = FirebaseStorage.instance
          .ref()
          .child('images')
          .child(DateTime.now().toString());

      // Upload the file to Firebase Storage
      TaskSnapshot uploadTask = await ref.putFile(File(imagePath));

      // Get the download URL of the uploaded file
      imageUrl = await uploadTask.ref.getDownloadURL();
    } catch (error) {
      print('Error uploading image to Firebase Storage: $error');
    }
    return imageUrl;
  }
}
