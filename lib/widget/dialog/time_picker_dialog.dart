import 'package:demo/core/strings.dart';
import 'package:flutter/cupertino.dart';

Future<int?> showCupertinoMonthPicker(BuildContext context) async {
  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  return showCupertinoDialog<int>(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title:  const Text(Strings.selectMonthLabel),
        content: SingleChildScrollView(
          child: ListBody(
            children: months.asMap().entries.map((entry) {
              int idx = entry.key;
              String month = entry.value;
              return CupertinoDialogAction(
                child: Text(month,),
                onPressed: () {
                  Navigator.of(context)
                      .pop(idx + 1); // Return the month index (1-12)
                },
              );
            }).toList(),
          ),
        ),
      );
    },
  );
}
