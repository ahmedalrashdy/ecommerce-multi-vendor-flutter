import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce/core/extensions/app_theme_extension.dart';

class CustomConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final String? confirmText;
  final String? cancelText;
  final Color? confirmColor;
  final IconData? icon;
  final bool isDestructive;

  const CustomConfirmationDialog(
      {super.key,
      required this.title,
      required this.content,
      required this.onConfirm,
      this.confirmText,
      this.cancelText,
      this.confirmColor,
      this.icon,
      this.isDestructive = false,
      this.onCancel});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;

    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: screenSize.width * (isSmallScreen ? 0.9 : 0.8),
        constraints: const BoxConstraints(
          maxWidth: 400,
          minWidth: 280,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with icon
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
              decoration: BoxDecoration(
                color: isDestructive
                    ? Colors.red.shade50
                    : context.colors.primary.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDestructive
                          ? Colors.red.shade100
                          : context.colors.primary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon ??
                          (isDestructive
                              ? Icons.warning_rounded
                              : Icons.info_rounded),
                      color: isDestructive
                          ? Colors.red.shade400
                          : context.colors.primary,
                      size: isSmallScreen ? 24 : 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isSmallScreen ? 18 : 20,
                          color: isDestructive
                              ? Colors.red.shade400
                              : context.colors.primary),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
              child: Text(
                content,
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  height: 1.5,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            // Actions
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Cancel Button
                  TextButton(
                    onPressed: () {
                      context.pop();
                      if (onCancel != null) {
                        onCancel!();
                      }
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 12 : 16,
                        vertical: isSmallScreen ? 8 : 10,
                      ),
                    ),
                    child: Text(
                      cancelText ?? "إلغاء",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: isSmallScreen ? 14 : 16,
                      ),
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 8 : 12),
                  // Confirm Button
                  ElevatedButton(
                    onPressed: () {
                      context.pop();
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: confirmColor ??
                          (isDestructive
                              ? Colors.red.shade400
                              : context.colors.primary),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 16 : 20,
                        vertical: isSmallScreen ? 8 : 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      confirmText ?? (isDestructive ? "مسح" : "تأكيد"),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: isSmallScreen ? 14 : 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
