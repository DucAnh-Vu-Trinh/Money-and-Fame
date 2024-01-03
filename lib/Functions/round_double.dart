import 'dart:math';
double roundOffToXDecimal(double number, {int numberOfDecimal = 2}) {
  // To prevent number that ends with 5 not round up correctly in Dart (eg: 2.275 round off to 2.27 instead of 2.28)
  String numbersAfterDecimal = number.toString().split('.')[1];
  if (numbersAfterDecimal != '0') {
    int existingNumberOfDecimal = numbersAfterDecimal.length;
    double incrementValue = 1 / (10 * pow(10, existingNumberOfDecimal));
    if (number < 0) {
       number -= incrementValue;
    } else {
       number += incrementValue;
    }
  }

  return double.parse(number.toStringAsFixed(numberOfDecimal));
}