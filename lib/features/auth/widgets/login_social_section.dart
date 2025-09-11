import 'package:flutter/material.dart';
import 'package:ecommerce/core/consts/app_assets.dart';
import 'social_login_divider.dart';
import 'social_media_button.dart';

class SocialLoginSection extends StatelessWidget {
  const SocialLoginSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SocialLoginDivider(text: "أو سجل الدخول بواسطة"),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SocialMediaButton(
              onPressed: () {
                print("Google Login Tapped");
              },
              icon: AppAssets.imagesGoogle,
              text: "Google", // تأكد من المسار
            ),
            const SizedBox(width: 24),
            SocialMediaButton(
              onPressed: () {
                // TODO: Implement Facebook Login
                print("Facebook Login Tapped");
              },
              icon: AppAssets.imagesFacebook, // تأكد من المسار
              text: 'Facebook',
            ),
            // يمكنك إضافة المزيد من الأزرار هنا
            // const SizedBox(width: 24),
            // SocialMediaButton(
            //   onPressed: () {},
            //   iconPath: AppAssets.imagesApple,
            // ),
          ],
        ),
      ],
    );
  }
}
