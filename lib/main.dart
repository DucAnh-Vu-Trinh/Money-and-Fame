import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:my_test_app/Welcome/welcome_page.dart';
import 'package:my_test_app/Functions/Preferences/model_theme.dart';

void main() {
  runApp(const MyApp());
}
 
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (_) => ModelTheme(),
      child: Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
          return MaterialApp(
            theme: themeNotifier.isDark? 
              ThemeData(
                brightness: Brightness.dark,
              )
              : ThemeData(
                brightness: Brightness.light,
              ),
            home: const WelcomeScreen(),
          );
        }
      ),
    );
  }
}