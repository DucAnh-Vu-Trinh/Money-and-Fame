import 'dart:math';
import 'package:excel/excel.dart';
import 'package:my_test_app/Functions/handle_excel.dart';
import 'package:my_test_app/Functions/round_double.dart';

Map<String, List<String>> summary (Excel excel, List listName, String table) {
  List<List<CellValue>> twoDList = decodeExcelObject(excel);
  int maxRow = excel.tables[table]!.maxRows;
  int totalPpl = listName.length;
  Map<String, List<String>> Summary = {};
  List<String> payMoney = [];
  List<String> saveMoney = [];
  List<String> spendMoney = [];
  List<String> totalMoney = [];

  // Calculate who owes owes who how much money
  var oweMoney = oweMoneySum(twoDList, totalPpl, maxRow);
  oweMoney.forEach((key, value) {});
  oweMoney.forEach((key, value) {
    if (value > 0){
      var owner = listName[int.parse(key[1]) - 1];
      var payer = listName[int.parse(key[0]) - 1];
      payMoney.add('$payer has to pay $owner ${roundOffToXDecimal (value)}');
    }
    else if (value < 0){
      var payer = listName[int.parse(key[1]) - 1];
      var owner = listName[int.parse(key[0]) - 1];
      payMoney.add('$payer has to pay $owner ${roundOffToXDecimal (value.abs())}');
    }
    else{
      return;
    }
  });
  
  // Calculate who spends/ saves how much money
  var (saveMoneyList, spendMoneyList) = spendMoneySum(twoDList, totalPpl, maxRow);
  saveMoneyList.asMap().forEach( (index, money){
    saveMoney.add('${listName[index]} earn ${roundOffToXDecimal (money)}');
  });
  spendMoneyList.asMap().forEach( (index, money){
    spendMoney.add('${listName[index]} spend ${roundOffToXDecimal (money.abs())}');
  });

  // Calculate total cash flow
  listName.asMap().forEach( (index, name){
    var total = saveMoneyList[index] + spendMoneyList[index];
    if (total < 0){
      totalMoney.add('${listName[index]} loses ${roundOffToXDecimal (total.abs())}');
    }
    else if (total > 0){
      totalMoney.add('${listName[index]} earns ${roundOffToXDecimal (total)}');
    }
  });

  Summary['Who owes Who?'] = payMoney;
  Summary['Earn money'] = saveMoney;
  Summary['Spend money'] = spendMoney;
  Summary['Total cash flow'] = totalMoney;

  return Summary;
}

(List, List) spendMoneySum (List<List<CellValue>> twoDList, int totalPpl, int maxRow){
  List<double> spendMoney = List<double>.filled(totalPpl, 0);
  List<double> saveMoney = List<double>.filled(totalPpl, 0);

  for (var i = 1; i < maxRow; i++){
    for (var k = 0; k < totalPpl; k++){
      double moneyValue = 0;
      var value = twoDList[i][k];
      switch (value){
        case DoubleCellValue():
          moneyValue = value.value;
        case IntCellValue():
          moneyValue = value.value.toDouble();
        case TextCellValue():
          moneyValue = double.parse(value.value);
        default:
          moneyValue = moneyValue;
      }
      if (moneyValue > 0){
        saveMoney[k] += moneyValue;
      }
      else if (moneyValue < 0){
        spendMoney[k] += moneyValue;
      }
    }
  }
  return (saveMoney, spendMoney);
}

Map<List<String>, double> oweMoneySum (List<List<CellValue>> twoDList, int totalPpl, int maxRow){
  Map<List<String>, double> oweMoney = {};
  Map<int, double> oweMoneyIntKey = {};
  for (var i = 1; i < maxRow; i++){
    var count = 0;
    int key = 0;
    for (var k = 0; k < totalPpl; k++){
      double moneyValue = 0;
      var value = twoDList[i][k];
      switch (value){
        case DoubleCellValue():
          moneyValue = value.value;
        case IntCellValue():
          moneyValue = value.value.toDouble();
        case TextCellValue():
          moneyValue = double.parse(value.value);
        default:
          moneyValue = moneyValue;
      }
      
      if (moneyValue != 0){
        key = key + (k + 1) * pow(10, count).toInt();
        count = count + 1;
      }
      if (count == 2){
        if (oweMoneyIntKey.containsKey(key)){
          oweMoneyIntKey[key] = oweMoneyIntKey[key]! + moneyValue;
        }
        else{
          oweMoneyIntKey[key] = moneyValue;
        }
      }
    }
  }
  oweMoneyIntKey.forEach((key, value) {
    oweMoney[key.toString().split('')] = value;
  });

  return oweMoney;
}