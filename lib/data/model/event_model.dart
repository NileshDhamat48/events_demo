import 'package:intl/intl.dart';

class Events {
  int? id;
  String? title;
  String? description;
  DateTime? date;

  Events({
    this.id,
    this.title,
    this.description,
    this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date != null ? DateFormat('yyyy-MM-dd HH:mm').format(date!) : '',
    };
  }
}
