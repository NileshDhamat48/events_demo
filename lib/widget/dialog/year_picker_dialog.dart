import 'package:demo/core/strings.dart';
import 'package:flutter/cupertino.dart';

Future<int?> showCupertinoYearPicker(BuildContext context) async {
  final List<int> years =
      List.generate(10, (index) => 2016 + index); // Years from 2016 to 2025

  return showCupertinoDialog<int>(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: const Text(Strings.selectYearLabel),
        content: SingleChildScrollView(
          child: ListBody(
            children: years.map((year) {
              return CupertinoDialogAction(
                child: Text(year.toString()),
                onPressed: () {
                  Navigator.of(context).pop(year); // Return the selected year
                },
              );
            }).toList(),
          ),
        ),
      );
    },
  );
}
