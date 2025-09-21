import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce/core/widgets/custom_bottom_nav_bar.dart';
import 'package:ecommerce/core/widgets/main_drawer.dart';
import 'core/blocs/auth/auth_bloc.dart';
import 'core/blocs/auth/auth_state.dart';
import 'core/consts/app_routes.dart';
import 'core/widgets/custom_confirm_diolog.dart';

class MainScreen extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainScreen({
    Key? key,
    required this.navigationShell,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  void _onItemTapped(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoginRequired) {
          showDialog(
              context: context,
              builder: (ctx) {
                return CustomConfirmationDialog(
                  content: state.message,
                  onConfirm: () {
                    context.go(AppRoutes.loginScreen);
                  },
                  onCancel: () {},
                  title: "الانتقال الى تسجيل الدخول",
                );
              });
        }
      },
      child: Scaffold(
        body: SafeArea(child: widget.navigationShell),
        bottomNavigationBar: CustomBottomNavBar(
          onItemTapped: _onItemTapped,
          selectedIndex: widget.navigationShell.currentIndex,
        ),
        drawer: CustomDrawer(),
      ),
    );
  }
}
