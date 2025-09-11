import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ecommerce/core/consts/app_assets.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key, this.height = 80, this.textHeight = 50});
  final double height;
  final double textHeight;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          AppAssets.imagesLogoSvg,
          height: height,
        ),
        Transform.translate(
          offset: Offset(0, -15),
          child: SvgPicture.asset(
            AppAssets.imagesLogoText,
            height: textHeight,
          ),
        )
      ],
    );
  }
}
