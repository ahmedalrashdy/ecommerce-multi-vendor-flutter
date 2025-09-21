// lib/core/widgets/custom_bottom_nav_bar.dart
import 'package:flutter/material.dart';
import 'package:ecommerce/core/extensions/app_theme_extension.dart';

class CustomBottomNavBar extends StatefulWidget {
  final void Function(int) onItemTapped;
  final int selectedIndex;
  const CustomBottomNavBar(
      {super.key, this.selectedIndex = 0, required this.onItemTapped});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    final appColors = context.colors;

    return BottomNavigationBar(
      currentIndex: widget.selectedIndex,
      onTap: widget.onItemTapped,
      type: BottomNavigationBarType.fixed,
      backgroundColor: appColors.card,
      selectedItemColor: appColors.primary,
      unselectedItemColor: appColors.secondaryText,
      showUnselectedLabels: true,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled), // أيقونة البيت
          label: 'الرئيسية',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined), // أيقونة السلة
          label: 'السلة',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border_outlined), // أيقونة السلة
          label: 'المفضلة',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long), // أيقونة الفواتير/الطلبات
          label: 'طلباتي',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person), // أيقونة الحساب الشخصي
          label: 'حسابي',
        ),
      ],
    );
  }
}
