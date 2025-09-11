import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ecommerce/core/extensions/app_theme_extension.dart';

class DeleteOverlay extends StatelessWidget {
  const DeleteOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.onSurface.withOpacity(.3),
        borderRadius: BorderRadius.circular(18),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: context.colors.surface,
            ),
            const SizedBox(width: 8),
            Text(
              "جاري الحذف",
              style: TextStyle(
                color: context.colors.surface,
              ),
            )
          ],
        ),
      ),
    );
  }
}
