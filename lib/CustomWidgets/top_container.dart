import 'package:flutter/material.dart';
import 'package:my_test_app/CustomWidgets/light_colors.dart';
import 'package:my_test_app/Functions/Preferences/model_theme.dart';

class TopContainer extends StatelessWidget {
  final double? height;
  final double? width;
  final Widget? child;
  final EdgeInsets? padding;
  final ModelTheme themeNotifier;
  const TopContainer({super.key, this.height, this.width, this.child, this.padding, required this.themeNotifier});

  @override
  Widget build( BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: themeNotifier.isDark ? DarkColors.kDarkerYellow : LightColors.kDarkYellow,
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(40.0),
          bottomLeft: Radius.circular(40.0),
        )
      ),
      height: height,
      width: width,
      child: child,
    );
  }
}