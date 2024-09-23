import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateUtil {
  static int getDateTimEStamp(DateTime date) {
    final finalDate = DateTime(date.year, date.month, date.day);
    return finalDate.microsecondsSinceEpoch;
  }

  static String getFormatedDate(DateTime date) {
    try {
      return DateFormat('MMM-yyyy').format(date);
    } catch (e) {
      return '';
    }
  }

  static String getMonthName(int month) {
    // Check if the month is valid
    if (month < 1 || month > 12) {
      throw Exception('Invalid month: $month. Must be between 1 and 12.');
    }

    // Create a DateTime object for the 1st day of the given month and year
    DateTime date = DateTime(2023, month); // Year is arbitrary
    // Return the month name
    return DateFormat.MMM().format(date); // Abbreviated month name
  }

  static String geFormateDateTime(DateTime? dateTime) {
    try {
      if (dateTime != null) {
        return DateFormat('HH:mm d-MMM-yyyy').format(dateTime);
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  static String geFormateDateYYYYMMdd(DateTime date) {
    try {
      return DateFormat('yyyy-MM-dd').format(date);
    } catch (e) {
      return '';
    }
  }

  static DateTime? dateTimeFromString(String value) {
    try {
      DateFormat format = DateFormat('HH:mm d-MMM-yyyy');

      // Parse the string to a DateTime object
      DateTime dateTime = format.parse(value);

      return dateTime;
    } catch (e) {
      return null;
    }
  }

  static String formateTime(TimeOfDay timeOfDay) {
    return "${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}";
  }

  static TimeOfDay convertDateTimeToTimeOfDay(DateTime dateTime) {
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }
}
