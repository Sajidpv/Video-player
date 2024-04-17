import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video_player_lilac/cores/theme/color_pellets.dart';
import 'package:video_player_lilac/cores/utils/pick_image.dart';
import 'package:video_player_lilac/cores/widgets/spacer.dart';
import 'package:video_player_lilac/features/auth/data/database/firestore_db.dart';
import 'package:video_player_lilac/features/auth/presentation/widgets/auth_field.dart';
import 'package:video_player_lilac/features/auth/presentation/widgets/auth_gradient_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  static route() => MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      );

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _firebase = FirebaseAuth.instance;
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<String> selectedTopics = [];
  File? image;

  void selectImage() async {
    final pickedImage = await pickImage();

    setState(() {
      image = pickedImage;
    });
  }

  Stream? UserStream;

  void updateProfile(userInfoMap, String id) async {
    DataBase.updateProfile(userInfoMap, id);
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Manage Profile'),
          actions: [
            TextButton(onPressed: () {}, child: const Text('Skip')),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  image != null
                      ? GestureDetector(
                          onTap: () => selectImage(),
                          child: SizedBox(
                              height: 130,
                              width: 120,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  image!,
                                  fit: BoxFit.cover,
                                ),
                              )),
                        )
                      : GestureDetector(
                          onTap: () {
                            selectImage;
                          },
                          child: DottedBorder(
                              color: AppPallete.borderColor,
                              radius: const Radius.circular(100),
                              borderType: BorderType.RRect,
                              strokeCap: StrokeCap.round,
                              dashPattern: const [10, 4],
                              child: const SizedBox(
                                height: 150,
                                width: 150,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.folder_open,
                                      size: 30,
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      textAlign: TextAlign.center,
                                      'Select your image',
                                      style: TextStyle(fontSize: 15),
                                    )
                                  ],
                                ),
                              )),
                        ),
                  const SpacerWidget(
                    height: 20,
                  ),
                  AuthField(controller: titleController, hintText: 'Name'),
                  const SpacerWidget(),
                  AuthField(controller: contentController, hintText: 'Email'),
                  const SpacerWidget(),
                  AuthField(controller: contentController, hintText: 'DOB'),
                  const SpacerWidget(
                    height: 30,
                  ),
                  AuthGradientButton(
                      buttonText: 'Save',
                      onPressed: () async {
                        String imageUrl =
                            await DataBase.uploadImageToFirebaseStorage(
                                image!.path);
                        Map<String, dynamic> userInfo = {
                          'name': titleController.text.trim(),
                          'email': contentController.text.trim(),
                          'dob': contentController.text.trim(),
                          'image': imageUrl
                        };
                        updateProfile(userInfo, _firebase.currentUser!.uid);
                      }),
                ],
              ),
            ),
          ),
        ));
  }
}
