import 'package:flutter/material.dart';
import 'package:kooginapp/core/theme/pallete.dart';

class RoundedSmallButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final Color backgroundColor;
  final Color textColor;
  const RoundedSmallButton(
      {super.key,
      required this.onTap,
      required this.label,
      this.backgroundColor = Pallete.blueColor,
      this.textColor = Pallete.whiteColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 35,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Pallete.blueColor,
          ),
          child: Text(
            label,
            style: const TextStyle(color: Pallete.whiteColor, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ));
  }
}
