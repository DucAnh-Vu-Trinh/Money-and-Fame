import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:my_test_app/Pages/second_page.dart';
import 'package:my_test_app/Pages/Welcome/items.dart';
import 'package:my_test_app/CustomWidgets/light_colors.dart';
import 'package:my_test_app/Pages/first_page.dart';
import 'package:my_test_app/Functions/handle_excel.dart';
import 'package:my_test_app/Functions/Preferences/model_theme.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
 
 // ignore: library_private_types_in_public_api
 @override _WelcomeScreen createState() => _WelcomeScreen(); 
 }

class _WelcomeScreen extends State<WelcomeScreen> {
  List<Widget> slides = items
      .map((item) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Image.asset(
                  item['image'],
                  fit: BoxFit.fitWidth,
                  width: 220.0,
                  alignment: Alignment.bottomCenter,
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: <Widget>[
                      FittedBox(
                        fit: BoxFit.contain,
                        child: Text(item['header'],
                          style: const TextStyle(
                            fontSize: 50.0,
                            fontWeight: FontWeight.w300,
                            color: Color(0XFF3F3D56),
                            height: 2.0
                          )
                        ),
                      ),
                      Text(
                        item['description'],
                        style: const TextStyle(
                            color: Colors.grey,
                            letterSpacing: 1.2,
                            fontSize: 16.0,
                            height: 1.3),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              )
            ],
          )))
      .toList();

  List<Widget> indicator() => List<Widget>.generate(
    slides.length,
    (index) => Container(
      margin: const EdgeInsets.symmetric(horizontal: 3.0),
      height: 10.0,
      width: 10.0,
      decoration: BoxDecoration(
          color: currentPage.round() == index
            ? const Color(0XFF256075)
            : const Color(0XFF256075).withOpacity(0.2),
          borderRadius: BorderRadius.circular(10.0)),
      )
    );

  double currentPage = 0.0;
  final _pageViewController = PageController();
  
  @override
  void initState() {
    super.initState();
    _pageViewController.addListener(() {
      setState(() {
        currentPage = _pageViewController.page!;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
      builder: (context, ModelTheme themeNotifier, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white70,
            actions: [
              IconButton(
                icon: Icon(themeNotifier.isDark
                  ? Icons.nightlight_round
                  : Icons.wb_sunny),
                onPressed: () {themeNotifier.isDark
                  ? themeNotifier.isDark = false
                  : themeNotifier.isDark = true;
                }
              )
            ]),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>const MyHomePage()),
                  );
                },
                child: const Text('Create New',
                  style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: LightColors.kPurpleBlue,
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              InkWell(
                onTap: () async {
                  var myExcelFile = await pickFile();
                  var names = myExcelFile.item1;
                  Excel? excelFile = myExcelFile.item2;
                  String? fileName = myExcelFile.item3;

                  if (excelFile == null) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateNewTaskPage(names: names, excel: excelFile, fileName: fileName,)),
                  );
                },
                child: const Text('Import Old File',
                  style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: LightColors.kPurpleBlue,
                  ),
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
          body: Container(
            child: Stack(
              children: <Widget>[
                PageView.builder(
                  controller: _pageViewController,
                  itemCount: slides.length,
                  itemBuilder: (BuildContext context, int index) {
                    return slides[index];
                  },
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: const EdgeInsets.only(top: 70.0),
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: indicator(),
                          ),
                        ]
                      )
                    )
                  ),
              ],
            ),
          ),
        );
      }
    );
  }
}