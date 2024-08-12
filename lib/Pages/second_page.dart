import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:provider/provider.dart';

import 'package:my_test_app/CustomWidgets/alert_dialog.dart';
import 'package:my_test_app/CustomWidgets/date_form.dart';
import 'package:my_test_app/CustomWidgets/light_colors.dart';
import 'package:my_test_app/CustomWidgets/top_container.dart';
import 'package:my_test_app/CustomWidgets/back_button.dart';
import 'package:my_test_app/CustomWidgets/my_text_field.dart';

import 'package:my_test_app/Functions/handle_excel.dart';
import 'package:my_test_app/Pages/summary_page.dart';
import 'package:my_test_app/Functions/summary_calculation.dart';
import 'package:my_test_app/Functions/Preferences/model_theme.dart';

// import 'package:intl/date_symbol_data_local.dart';

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {super.key,
    required this.gradient,
    this.style,
  });

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}

// ignore: must_be_immutable
class CreateNewTaskPage extends StatelessWidget {
  late Map<String, List<List<CellValue>>> names;
  late Excel? excel;
  late String? fileName;
  CreateNewTaskPage ({super.key, required this.names, required this.excel, this.fileName = 'MoneyandFame'});
  
  final myController1 = TextEditingController();
  final myController2 = TextEditingController();
  final myController3 = TextEditingController();
  final myControllerTitle = TextEditingController();
  final myControllerDate = TextEditingController();
  
  void addEntries(List<dynamic>nameList, String chooseSheet, BuildContext context) {
    String debtor = myController1.text;
    String owner = myController2.text;
    String title = myControllerTitle.text;
    String date = myControllerDate.text;
    late DoubleCellValue money;

    try {
      money = DoubleCellValue(double.parse(myController3.text));
    } on FormatException {
      return;
    }
  
    var sheetObject = excel?.tables[chooseSheet];
    var maxRow = sheetObject!.maxRows;
    
    var debtorIndex = nameList.indexOf(debtor);
    var ownerIndex = nameList.indexOf(owner);
    var titleIndex = nameList.indexOf('Title');
    var dateIndex = nameList.indexOf('Date');
    final dataList = List<CellValue> .filled(nameList.length, const DoubleCellValue(0));

    if (debtorIndex != -1 && ownerIndex != -1){
      dataList[debtorIndex] = money;
      dataList[ownerIndex] = DoubleCellValue(-(money.value));
    }
    else if (debtorIndex != -1){
      dataList[debtorIndex] = money;
    }
    else if (ownerIndex != -1){
      dataList[ownerIndex] = DoubleCellValue(-(money.value));
    }
    else {
      const snackBar = SnackBar(
        content: Text('No Entries Added since both Gain and Lost unknown')
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    dataList[titleIndex] = TextCellValue(title);
    dataList[dateIndex] = TextCellValue(date);

    sheetObject.insertRowIterables(dataList, maxRow);
    const snackBar = SnackBar(
      content: Text('Entries Added. Click "Update Excel" to inspect')
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void deleteEntries(String chooseSheet, BuildContext context) {
    var sheetObject = excel?.tables[chooseSheet];
    var maxRow = sheetObject!.maxRows;

    showAlertDialog(
      title: 'Be Careful !!!', 
      content: 'Delete the Last Row?', 
      context: context,
      yesOnPress: () {
        excel!.tables[chooseSheet]!.removeRow(maxRow - 1);
        Navigator.pop(context);
        }
      );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    List<String> sheetNames = [];

    names.removeWhere((key, value) => key == 'null'); //names is a Map with key = Excel's Sheet name and values = 2D list (rows x columns)
    for (var sheetName in names.keys){
      sheetNames.add(sheetName);
    }

    //Make a button for Choose Sheet Name
    String choosenSheetName = 'Sheet1';
    var myListName = names[choosenSheetName]![0];
    List<String> myListNameStr = [];
    for (var title in myListName){
      switch (title){
        case TextCellValue():
          myListNameStr.add(title.value);
        default:
          myListNameStr = myListNameStr;
      }
    }
    myListNameStr.removeWhere((element) => element == '');
    var myListPplName = myListNameStr.sublist(0, myListName.length - 2);
    // print (getName().runtimeType);
    // var mapofname = getName();

    var downwardIcon = const Icon(
      Icons.keyboard_arrow_down,
      color: Colors.black54,
    );
    // Generate summary data for summary page

    return Consumer<ModelTheme>(
      builder: (context, ModelTheme themeNotifier, child) {
  
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Column(
              children: <Widget>[
                TopContainer(
                  themeNotifier: themeNotifier,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                  width: width,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const MyBackButton(heroTag: 'backButtonSecondPage',),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            IconButton(
                            onPressed: () async {
                              var myExcelFile = await pickFile();
                              if (myExcelFile.item2 == null){
                                return;
                              }
                              names = myExcelFile.item1;
                              excel = myExcelFile.item2;
                            },
                            icon: Icon(
                              Icons.drive_file_move_outline,
                              color: themeNotifier.isDark ? Colors.grey : Colors.white,
                            ),
                            tooltip: 'Different Excel File',
                            iconSize: 35,
                            highlightColor: const Color.fromARGB(255, 249, 202, 61),
                          ),
                          IconButton(
                            onPressed: () {
                              Map<String, List<String>> summaryData = summary(excel!, myListPplName, choosenSheetName);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SummaryPage(summaryData: summaryData)),
                              );
                            },
                            iconSize: 32,
                            icon: Icon(
                              Icons.summarize_outlined,
                              color: themeNotifier.isDark ? Colors.grey : Colors.white,
                            ),
                            tooltip: 'Summary Page',
                            )
                          ],
                        )
                        ]
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Create new budget',
                            style: TextStyle(
                                fontSize: 30.0, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          MyTextField(
                            label: 'Title',
                            controller: myControllerTitle,
                            textInputAction: TextInputAction.next,
                            themeNotifier: themeNotifier,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Expanded(
                                child: MyCustomDateForm(myControllerDate: myControllerDate)
                              ),
                              const CircleAvatar(
                                radius: 25.0,
                                backgroundColor: LightColors.kGreen,
                                child: Icon(
                                  Icons.calendar_today,
                                  size: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        ],
                      ))
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                              child: MyTextFieldPop(
                                themeNotifier: themeNotifier,
                                controller: myController1,
                                label: 'Who Gain',
                                icon: downwardIcon,
                                items: myListPplName,
                                readOnly: true,
                              )),
                          const SizedBox(width: 40),
                          Expanded(
                            child: MyTextFieldPop(
                              themeNotifier: themeNotifier,
                              controller: myController2,
                              label: 'Who Lost',
                              icon: downwardIcon,
                              items: myListPplName,
                              readOnly: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      MyTextField(
                        textInputType: TextInputType.text,
                        themeNotifier: themeNotifier,
                        // textInputType: const TextInputType.numberWithOptions(decimal: true),
                        controller: myController3,
                        label: 'Amount',
                        minLines: 3,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Category',
                              style: TextStyle(
                                fontSize: 18,
                                color: themeNotifier.isDark ? Colors.white : Colors.black54,
                              ),
                            ),
                            const Wrap(
                              crossAxisAlignment: WrapCrossAlignment.start,
                              //direction: Axis.vertical,
                              alignment: WrapAlignment.start,
                              verticalDirection: VerticalDirection.down,
                              runSpacing: 0,
                              //textDirection: TextDirection.rtl,
                              spacing: 10.0,
                              children: <Widget>[
                                Chip(
                                  label: Text("Notes"),
                                  backgroundColor: LightColors.kRed,
                                  labelStyle: TextStyle(color: Colors.white),
                                ),
                                // Chip(
                                //   label: Text("MEDICAL APP"),
                                // ),
                                // Chip(
                                //   label: Text("RENT APP"),
                                // ),
                                // Chip(
                                //   label: Text("NOTES"),
                                // ),
                                // Chip(
                                //   label: Text("GAMING PLATFORM APP"),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
                FloatingActionButton.extended(
                  backgroundColor: LightColors.kGreen,
                  label: const GradientText(
                    'Update Excel',
                    style: TextStyle(
                      color: Colors.white,
                      // fontWeight: FontWeight.w700,
                      fontSize: 12,
                      ),
                    gradient: LinearGradient(
                      colors:
                        [LightColors.kLightYellow,
                        LightColors.kLightYellow,
                        ],
                    ),
                  ),
                  icon: const Icon(Icons.security_update_outlined),
                  onPressed: () async {
                    await promptForFileNameAndSave(context, excel!, fileName!, themeNotifier.platform);
                  }
                ),
                Container(
                  height: 80,
                  width: width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                        width: width - 40,
                        decoration: BoxDecoration(
                          color: themeNotifier.isDark ? DarkColors.kDarkBlue : LightColors.kBlue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: SizedBox(
                          height: double.infinity,
                          width: 400,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    // Customize appearance as needed, e.g.:
                                    backgroundColor: themeNotifier.isDark ? DarkColors.kDarkBlue : LightColors.kBlue,
                                    side: BorderSide(width: 3, color: themeNotifier.isDark ? DarkColors.kDarkRed : LightColors.kRed),
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  onPressed: () => deleteEntries(choosenSheetName, context), // Replace with your desired action
                                  child: const FittedBox(
                                    fit: BoxFit.fill,
                                    child: Text(
                                      'Delete Entries',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                      ),
                                    ),
                                  )
                                ),
                              ),
                              const SizedBox(width: 7,),
                              Expanded(
                                flex: 2,
                                child: ElevatedButton (
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: themeNotifier.isDark ? DarkColors.kDarkBlue : LightColors.kBlue, //background color of button
                                    side: BorderSide(width: 3, color:themeNotifier.isDark ? DarkColors.kDarkYellow2 : LightColors.kDarkYellow), //border width and color
                                    elevation: 3, //elevation of button
                                    shape: RoundedRectangleBorder( //to set border radius to button
                                      borderRadius: BorderRadius.circular(30)
                                      ),
                                      // padding: EdgeInsets.all(20) //content padding inside button
                                  ),
                                  onPressed: () => addEntries(myListNameStr, choosenSheetName, context),
                                  child: const FittedBox(
                                    fit: BoxFit.fill,
                                    child: Text(
                                      'Add Entries',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18),
                                    ),
                                  )
                                ),
                              ),
                            ],
                          )
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}