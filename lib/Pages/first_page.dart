import 'package:flutter/material.dart';
import 'package:my_test_app/Functions/handle_excel.dart';
import 'package:my_test_app/Pages/second_page.dart';
import 'package:my_test_app/CustomWidgets/light_colors.dart';
import 'package:excel/excel.dart';

// ignore: must_be_immutable
class DynamicItem extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  DynamicItem({super.key});
  
  @override
  Widget build (BuildContext context){
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(hintText: 'Enter Name',),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  _MyHomePageState createState () => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<DynamicItem> DynamicList = [];
  List<String> data = [];
  bool dataIsSubmitted = false;

  Icon floatingIcon = const Icon(Icons.add);
  Icon removeIcon = const Icon(Icons.remove);
  double removeIconOpacity = 1.0;

  Future<void> changeScreen() async {
    var myExcelFile = await pickFile();
    var names = myExcelFile.item1;
    Excel? excelFile = myExcelFile.item2;
    String? fileName = myExcelFile.item3;

    if (excelFile == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateNewTaskPage(names: names, excel: excelFile, fileName: fileName)
      ),
    );
  }
  
  void addDynamic() {
    int maxDataField = 5;

    if (DynamicList.length < maxDataField) {
      DynamicList.add(DynamicItem());
    }

    if (data.isNotEmpty) {
      floatingIcon = const Icon(Icons.add);
      removeIconOpacity = 1.0;

      data = [];
      if (DynamicList.length != maxDataField) {
        DynamicList.removeLast();
      }
    }
    setState(() {});
  }

  removeDynamic() {
    int minDataField = 1;
    if (data.isNotEmpty) {
      return null;
    }
  
    setState(() {});
    if (DynamicList.length <= minDataField) {
      return;
    }
    DynamicList.removeLast();
  }

  submitList() {
    floatingIcon = const Icon(Icons.arrow_back);
    removeIconOpacity = 0;
    data = [];
    DynamicList.forEach((widget) {
      String text = widget.controller.text;
      data.add(text);
  });
    setState(() {dataIsSubmitted = true;});
  }

  @override
  Widget build(BuildContext context) {
    Widget result =  Flexible(
        flex: 1,
        child: Card(
          elevation: 60,
          shadowColor: const Color.fromARGB(255, 123, 66, 245),
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (_, index) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(left: 10.0),
                      child: Text("${index + 1} : ${data[index]}"),
                    ),
                    const Divider()
                  ],
                ),
              );
            },
          ),
        ));

    Widget dynamicTextField = Flexible(
      flex: 2,
      child: ListView.builder(
        itemCount: DynamicList.length,
        itemBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    LightColors.kDarkYellow,
                    Colors.orange,
                  ]
                )
              ),
              child: DynamicList[index],
            )
          );
        } 
      ),
    );

    Widget submitBtn = ElevatedButton.icon(
      onPressed: submitList,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10.0))),
      label: const Text ('Done'),
      icon: const Icon(Icons.fact_check),
      );

    Widget createExcelBtn = ElevatedButton.icon(
      onPressed: () => createExcel(data),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 34, 133, 41),
        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10.0))),
      label: const Text ('Create Excel'),
      icon: const Icon(Icons.create),
    );
      
    return MaterialApp(
      theme: ThemeData (
        useMaterial3: true,
        // Define the default brightness and colors.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          // ···
          brightness: Brightness.light,
        ),

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('TienTaiDanhVong',
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w700, color: LightColors.kDarkYellow),),
          backgroundColor: LightColors.kRed,
          surfaceTintColor: LightColors.kDarkYellow,
          actions: [
            IconButton(
              onPressed: changeScreen,
              icon: const Icon(Icons.drive_file_move_outline),
              iconSize: 40,
              highlightColor: const Color.fromARGB(255, 249, 202, 61),
            ),
          ],
        ),
        body: Container(
          margin: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              data.isEmpty ? dynamicTextField : result,
              data.isEmpty ? submitBtn : createExcelBtn,
            ],
          ),
        ),
        floatingActionButton: Wrap(
          direction: Axis.vertical, //use vertical to show  on vertical axis
          children: <Widget>[
            Container( 
              margin:const EdgeInsets.all(10),
              child: FloatingActionButton(
                onPressed: addDynamic,
                child: floatingIcon,
              )
            ),
            
            Opacity(
              opacity: removeIconOpacity,
              child: Container( 
                margin: const EdgeInsets.all(10),
                child: FloatingActionButton(
                  onPressed: removeDynamic,
                  backgroundColor: Colors.deepPurpleAccent,
                  child: const Icon(Icons.remove),
                ),
              ),
            )
          ]
        ) 
      ),
    );
  }
}