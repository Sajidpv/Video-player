import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputType input;
  final String? prefix;
  const AuthField({
    super.key,
    required this.hintText,
    required this.controller,
    this.input = TextInputType.text,
    this.prefix = '',
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefix: prefix != null ? Text(prefix!) : null,
        hintText: hintText,
      ),
      keyboardType: input,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty) {
          return "$hintText required.";
        }
        if (controller.text.length < 10) {
          return "$hintText should be 10 digits ";
        }
        return null;
      },
    );
  }
}
