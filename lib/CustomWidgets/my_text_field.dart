import 'package:flutter/material.dart';
import 'package:my_test_app/Functions/Preferences/model_theme.dart';

// ignore: must_be_immutable
class MyTextField extends StatelessWidget {
  final String label;
  final int maxLines;
  final int minLines;
  final Icon? icon;
  final TextEditingController? controller;
  final Decoration? decoration;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final Function()? onTap;
  final ModelTheme themeNotifier;
  bool readOnly;

  MyTextField({super.key, required this.label, required this.themeNotifier, this.maxLines = 1, this.minLines = 1, this.icon, this.controller, this.decoration, this.readOnly = false, this.onTap, this.textInputType = TextInputType.text, this.textInputAction = TextInputAction.done});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: readOnly,
      controller: controller,
      keyboardType: textInputType,
      textInputAction: textInputAction,
      style: TextStyle(color: themeNotifier.isDark ? Colors.white70 : Colors.black87),
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
        suffixIcon:
          icon ?? icon,
          labelText: label,
          labelStyle: TextStyle(color: themeNotifier.isDark ? Colors.white60 : Colors.black45),
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey))),
    );
  }
}

// ignore: must_be_immutable
class MyTextFieldPop extends StatelessWidget {
  final String label;
  final int maxLines;
  final int minLines;
  final Icon? icon;
  final TextEditingController? controller;
  final Decoration? decoration;
  final List<dynamic> items;
  final ModelTheme themeNotifier;
  bool readOnly;

  MyTextFieldPop({super.key, required this.label, this.maxLines = 1, this.minLines = 1, this.icon, this.controller, this.decoration, required this.items, required this.themeNotifier, this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      controller: controller,
      style: TextStyle(color: themeNotifier.isDark ? Colors.white38 : Colors.black87),
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: themeNotifier.isDark ? Colors.white60 : Colors.black45),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        suffixIcon: PopupMenuButton<String>(
          icon: const Icon(Icons.arrow_drop_down),
          onSelected: (String value) {
            controller!.text = value;
          },
          itemBuilder: (BuildContext context) {
            return items.map<PopupMenuItem<String>>((dynamic value) {
              return PopupMenuItem(
                value: value,
                child: Text(value),
                );
            }).toList();
          },
        ),
      ),
          // icon == null ? null: icon,
          // labelText: label,
          // labelStyle: TextStyle(color: Colors.black45),
          // focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          // border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey))),
    );
  }
}