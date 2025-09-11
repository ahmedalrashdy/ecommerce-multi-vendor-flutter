import 'package:flutter/material.dart';

class SocialMediaButton extends StatelessWidget {
  SocialMediaButton(
      {super.key,
      required this.onPressed,
      required this.icon,
      required this.text,
      this.backgroundColor,
      this.textColor});
  VoidCallback onPressed;
  String icon;
  String text;
  Color? backgroundColor;
  Color? textColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              icon,
              height: 24,
              width: 24,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
