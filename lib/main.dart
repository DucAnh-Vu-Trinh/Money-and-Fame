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
            theme: ThemeData (
              // useMaterial3: true,
              // Define the default brightness and colors.
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.purple,
                // ···
                brightness: themeNotifier.isDark ? Brightness.dark : Brightness.light,
              ),

              // Define the default `TextTheme`. Use this to specify the default
              // text styling for headlines, titles, bodies of text, and more.
              // textTheme: const TextTheme(
              //   displayLarge: TextStyle(
              //     fontSize: 72,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
            ),
            home: const WelcomeScreen(),
          );
        }
      ),
    );
  }
}