import 'package:flutter/material.dart';

class TabContent extends StatefulWidget {
  final Widget child;
  const TabContent({required this.child, Key? key}) : super(key: key);

  @override
  _TabContentState createState() => _TabContentState();
}

class _TabContentState extends State<TabContent>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
