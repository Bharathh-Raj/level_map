import 'package:flutter/material.dart';

class MyBehavior extends ScrollBehavior {
  const MyBehavior();
  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}
