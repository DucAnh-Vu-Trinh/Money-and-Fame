import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:tuple/tuple.dart';
import 'dart:io';
// import 'package:shared_objects/shared_objects.dart';

Future<void> createExcel (List<String> names) async{
  // final Workbook workbook = Workbook();
  // final List<int> bytes = workbook.saveAsStream();
  // workbook.dispose();
  names.addAll(['Title', 'Date']);
  var excel = Excel.createExcel();
  Sheet sheetObject = excel['Sheet1'];
  // var cellA1 = sheetObject.cell(CellIndex.indexByString('A1'));
  // var cellB1 = sheetObject.cell(CellIndex.indexByString('B1'));
  List<CellValue> namesValue = [];
  for (var name in names){
    namesValue.add(TextCellValue(name));
  }
  sheetObject.appendRow(namesValue);

  var fileBytes = excel.save();
  List<int> nonNullablefileBytes = fileBytes ?? [];

  final String path = (await getApplicationSupportDirectory()).path;
  final String filename = '$path/TienTaiDanhVong.xlsx';
  // final File file = File (filename);
  // await file.writeAsBytes(fileBytes, flush: true);
  File(filename)
    ..createSync(recursive: true)
    ..writeAsBytesSync(nonNullablefileBytes);
  OpenFile.open(filename);
}

Future<void> updateExcel (Excel excel, String? fileName) async{
  // final Workbook workbook = Workbook();
  // final List<int> bytes = workbook.saveAsStream();
  // workbook.dispose();

  // var cellA1 = sheetObject.cell(CellIndex.indexByString('A1'));
  // var cellB1 = sheetObject.cell(CellIndex.indexByString('B1'));

  try {
    var fileBytes = excel.save();
    final String path = (await getApplicationSupportDirectory()).path;
    final String filename = '$path/$fileName.xlsx';
    // final File file = File (filename);
    // await file.writeAsBytes(fileBytes, flush: true);
    File(filename)
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);
    OpenFile.open(filename);
  } catch (e) {
      for (var table in excel.tables.keys) {
        // int col = excel.tables[table]!.maxColumns;
        // int row = excel.tables[table]!.maxRows;
      
        for (var row in excel.tables[table]!.rows) {
          for (var cell in row) {
            // print('cell ${cell!.rowIndex}/${cell.columnIndex}');
            final value = cell!.value;
            // final numFormat = cell.cellStyle?.numberFormat ?? NumFormat.standard_0;
            switch (value){
              case DoubleCellValue():
                cell.value = TextCellValue(value.value.toString());
              case IntCellValue():
                cell.value = TextCellValue(value.value.toString());
              default: {}
            }
          }
        }
      }
    }
  var fileBytes = excel.save();
  
  // List<int> nonNullablefileBytes = fileBytes ?? [];

  final String path = (await getApplicationSupportDirectory()).path;
  final String filename = '$path/TienTaiDanhVong.xlsx';
  // final File file = File (filename);
  // await file.writeAsBytes(fileBytes, flush: true);
  File(filename)
    ..createSync(recursive: true)
    ..writeAsBytesSync(fileBytes!);
  OpenFile.open(filename);
}

Future< Tuple3<Map<String, List<List<CellValue>>>, Excel?, String?> > pickFile() async {
  Map<String, List<List<CellValue>>> excelData = {};
  Excel? excel;
  String? fileName;

  FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom,
    allowedExtensions: ['xlsx'],
    allowMultiple: false,
  );

  if (result != null) {
    File file = File(result.files.single.path!);
    String fileNameWithExtension = file.uri.pathSegments.last;
    fileName = fileNameWithExtension.split('.').first;
    print(fileName);

    var bytes = file.readAsBytesSync();
    excel = Excel.decodeBytes(bytes);
    var tables = excel.tables.keys;
    String table = "Sheet1";

    for (table in tables) {
      table = table;
    }
    excelData[table] = decodeExcelObject (excel);
  }
  return Tuple3(excelData, excel, fileName);
}

List<List<CellValue>> decodeExcelObject (Excel? excel){
  List<List<CellValue>> twoDList = [[]];
  for (var table in excel!.tables.keys) {
    // print (excel[table].cell(CellIndex.indexByString('A1')));
    // print(table); //sheet Name
    // print(excel.tables[table]!.maxColumns);
    int col = excel.tables[table]!.maxColumns;
    int row = excel.tables[table]!.maxRows;
    // // print (excel[table].rows[0][1].runtimeType);
    // print(excel.tables[table]!.maxRows);
    // for (var row in excel.tables[table]!.rows) {
    //   print(row);
    // }
    twoDList = List<List<CellValue>>.generate(row, (i) => List<CellValue>.generate(col, (index) => const DoubleCellValue(0), growable: true), growable: true);
    
    for (var row in excel.tables[table]!.rows) {
      for (var cell in row) {
        // print('cell ${cell!.rowIndex}/${cell.columnIndex}');
        final value = cell!.value;
        // print (value.toString());
        // final numFormat = cell.cellStyle?.numberFormat ?? NumFormat.standard_0;
        twoDList[cell.rowIndex][cell.columnIndex] = value!;
      }
    }
  }
  return twoDList;
}