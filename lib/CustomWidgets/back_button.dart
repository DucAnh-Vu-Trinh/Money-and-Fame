import 'package:flutter/material.dart';
import 'package:my_test_app/CustomWidgets/light_colors.dart';


class MyBackButton extends StatelessWidget {
  final String heroTag;
  const MyBackButton({super.key, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
        child: GestureDetector(
        onTap: (){
          Navigator.pop(context);
        },
          child: const Align(
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.arrow_back_ios,
            size: 25,
            color: LightColors.kDarkBlue,
          ),
        ),
      ),
    );
  }
}