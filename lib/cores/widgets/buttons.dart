import 'package:flutter/material.dart';

SizedBox customButtons(
  BuildContext context,
  IconData icon, {
  VoidCallback? onClick,
}) {
  Color color = Theme.of(context).colorScheme.primary;
  return SizedBox(
    width: 50,
    height: 50,
    child: Material(
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onClick,
        child: Icon(
          icon,
          color: color,
          size: 20,
        ),
      ),
    ),
  );
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final IconData? icon;
  final Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              elevation: 0,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 17.0),
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)))),
          child: Row(
            children: [
              icon != null
                  ? Icon(
                      icon,
                    )
                  : const SizedBox(),
              Text(
                label,
                style: const TextStyle(color: Colors.black, fontSize: 14),
              ),
            ],
          )),
    );
  }
}
