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
      validator: (hintText == 'dd/mm/yyyy')
          ? customDateValidator
          : hintText == 'Email'
              ? emailValidator
              : (value) {
                  if (value!.isEmpty) {
                    return "$hintText required.";
                  }
                  if (hintText == 'Phone' && controller.text.length < 10) {
                    return "$hintText should be 10 digits ";
                  }

                  return null;
                },
    );
  }
}

String? customDateValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Date cannot be empty';
  }
  List<String> parts = value.split('/');

  if (parts.length != 3) {
    return 'Invalid date format';
  }
  int? day, month, year;
  try {
    day = int.parse(parts[0]);
    month = int.parse(parts[1]);
    year = int.parse(parts[2]);
  } catch (e) {
    return 'Invalid date format';
  }
  if (day < 1 ||
      day > 31 ||
      month < 1 ||
      month > 12 ||
      year < 1960 ||
      year > 2010) {
    return 'Invalid date';
  }
  return null;
}

String? emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email cannot be empty';
  }
  RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  if (!emailRegex.hasMatch(value)) {
    return 'Invalid email format';
  }
  return null;
}
