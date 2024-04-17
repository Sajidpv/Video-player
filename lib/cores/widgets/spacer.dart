import 'package:flutter/cupertino.dart';

class SpacerWidget extends StatelessWidget {
  const SpacerWidget({
    super.key,
    this.height = 10,
  });
  final double height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}
