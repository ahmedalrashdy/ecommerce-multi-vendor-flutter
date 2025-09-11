import 'package:flutter/material.dart';
import 'package:ecommerce/core/helpers/AppHelper.dart';

class AppMessage {
  static void showSuccess({
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showMessage(
      message: message,
      duration: duration,
      backgroundColor: Colors.green.shade800,
      icon: Icons.check_circle_outline,
      textColor: Colors.white,
    );
  }

  static void showError({
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showMessage(
      message: message,
      duration: duration,
      backgroundColor: Colors.red.shade800,
      icon: Icons.error_outline,
      textColor: Colors.white,
    );
  }

  static void showWarning({
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showMessage(
      message: message,
      duration: duration,
      backgroundColor: Colors.orange.shade800,
      icon: Icons.warning_amber_rounded,
      textColor: Colors.white,
    );
  }

  static void showInfo({
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showMessage(
      message: message,
      duration: duration,
      backgroundColor: Colors.blue.shade800,
      icon: Icons.info_outline,
      textColor: Colors.white,
    );
  }

  static void _showMessage({
    required String message,
    required Duration duration,
    required Color backgroundColor,
    required IconData icon,
    required Color textColor,
  }) {
    if (AppHelper.scaffoldMessengerKey.currentState == null) return;
    var scaffoldMessengerKey = AppHelper.scaffoldMessengerKey.currentState!;
    scaffoldMessengerKey.hideCurrentSnackBar();

    final snackBarContent = Row(
      children: [
        Icon(
          icon,
          color: textColor,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            message,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );

    final snackBar = SnackBar(
      content: snackBarContent,
      duration: duration,
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      dismissDirection: DismissDirection.horizontal,
    );
    scaffoldMessengerKey.showSnackBar(snackBar);
  }
}
