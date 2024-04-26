import 'package:flutter/material.dart';
import 'package:kooginapp/core/theme/theme.dart';

class PostIconButton extends StatelessWidget {
  final IconData theIcon;
  final String text;
  final VoidCallback onTap;
  const PostIconButton({super.key, required this.theIcon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(theIcon, color: Pallete.greyColor,),
          Container(
            margin: const EdgeInsets.all(8), 
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
