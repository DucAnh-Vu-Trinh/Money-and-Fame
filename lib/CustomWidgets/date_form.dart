import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_test_app/CustomWidgets/light_colors.dart';
import 'package:my_test_app/CustomWidgets/my_text_field.dart';

class MyCustomDateForm extends StatelessWidget {
  final TextEditingController myControllerDate;
  const MyCustomDateForm ({super.key, required this.myControllerDate});

  onTapDate ({required BuildContext context}) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      builder: (context, child) {return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: LightColors.kDarkYellow,
            onPrimary: Colors.black38,
            onSurface: LightColors.kGreen),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: LightColors.kRed)
          )
        ),
        child: child!,);
      },
      confirmText: "OKEY",
      cancelText: "NEGATIVE",
      initialDate: DateTime.now(),
      firstDate: DateTime(2003),
      //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime(2203));

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      myControllerDate.text = formattedDate; //set output date to TextField value.     
    } else {}
  }
  
  @override
  Widget build(BuildContext context){
    var downwardIcon = const Icon(
      Icons.keyboard_arrow_down,
      color: Colors.black54,
    );
    return 
      MyTextField(
        label: 'Date',
        icon: downwardIcon,
        controller: myControllerDate,
        readOnly: true,
        onTap: () => onTapDate(context: context),
    );
  }
}