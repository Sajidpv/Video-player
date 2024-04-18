import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_player_lilac/cores/theme/color_pellets.dart';
import 'package:video_player_lilac/cores/utils/pick_image.dart';
import 'package:video_player_lilac/cores/utils/show_snackbar.dart';
import 'package:video_player_lilac/cores/widgets/spacer.dart';
import 'package:video_player_lilac/features/auth/data/model/user_model.dart';
import 'package:video_player_lilac/features/auth/presentation/widgets/auth_field.dart';
import 'package:video_player_lilac/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:video_player_lilac/features/auth/services/firebase_methods.dart';
import 'package:video_player_lilac/features/player/presentation/pages/player.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, this.userData});

  static route({UserModel? user}) => MaterialPageRoute(
        builder: (context) => ProfilePage(
          userData: user,
        ),
      );
  final UserModel? userData;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Uint8List? _image;
  String imageUrl = '';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  final profileFormKey = GlobalKey<FormState>();

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void saveProfile() async {
    if (!profileFormKey.currentState!.validate()) {
      return;
    }
    if (_image == null) {
      showSnackBar(context, 'Select an image');
      return;
    }
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String dob = dobController.text.trim();

    String resp = await context
        .read<FirebaseAuthMethods>()
        .saveData(name: name, email: email, file: _image!, dob: dob);
    if (resp == 'success') {
      Navigator.pushReplacement(context, VideoPlayerScreen.route());
    }
    showSnackBar(context, resp);
  }

  @override
  void initState() {
    if (widget.userData != null) {
      nameController.text = widget.userData!.name!;
      emailController.text = widget.userData!.email!;
      dobController.text = widget.userData!.dob!;
      imageUrl = widget.userData!.image!;
    }
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    dobController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.userData != null ? 'Manage Profile' : 'Profile'),
        ),
        body: IgnorePointer(
          ignoring: widget.userData != null,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: profileFormKey,
                child: Column(
                  children: [
                    widget.userData != null
                        ? SizedBox(
                            height: 130,
                            width: 120,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                imageUrl,
                              ),
                            ))
                        : _image != null
                            ? GestureDetector(
                                onTap: selectImage,
                                child: SizedBox(
                                    height: 130,
                                    width: 120,
                                    child: CircleAvatar(
                                      backgroundImage: MemoryImage(
                                        _image!,
                                      ),
                                    )),
                              )
                            : GestureDetector(
                                onTap: selectImage,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                    AuthField(controller: nameController, hintText: 'Name'),
                    const SpacerWidget(),
                    AuthField(controller: emailController, hintText: 'Email'),
                    const SpacerWidget(),
                    AuthField(
                        controller: dobController, hintText: 'dd/mm/yyyy'),
                    const SpacerWidget(
                      height: 30,
                    ),
                    widget.userData != null
                        ? const SizedBox()
                        : AuthGradientButton(
                            buttonText: 'Save Profile', onPressed: saveProfile),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
