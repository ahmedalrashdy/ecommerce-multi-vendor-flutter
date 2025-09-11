import 'package:flutter/material.dart';
import 'package:ecommerce/core/widgets/main_drawer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      drawer: CustomDrawer(),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              scaffoldState.currentState?.openDrawer();
            },
            icon: Icon(Icons.menu)),
      ),
    );
  }
}
