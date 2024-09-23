import 'package:demo/data/local/database_helper.dart';
import 'package:demo/data/model/event_model.dart';
import 'package:demo/utils/date_utils.dart';
import 'package:flutter/material.dart';

class EventProvider extends ChangeNotifier {
  final _dbHelper = DatabaseHelper();

  List<Events> _tasks = [];

  List<Events> get tasks => _tasks;

  int _selectedYear = DateTime.now().year;

  int _selectedMonth = DateTime.now().month;

  int get year => _selectedYear;

  int get month => _selectedMonth;

  TimeOfDay selectedTime = TimeOfDay.now();

  String get formatedTime => DateUtil.formateTime(selectedTime);

  EventProvider() {
    _loadTasksFromDB();
  }

  void updateYear(int year) {
    _selectedYear = year;
    notifyListeners();
  }

  void updateMonth(int month) {
    _selectedMonth = month;
    notifyListeners();
  }

  void updateTime(TimeOfDay time, {bool notify = true}) {
    selectedTime = time;
    if (notify) {
      notifyListeners();
    }
  }

  List<int> getDaysInMonth() {
    final nextMonth = DateTime(year, month + 1, 1);
    final lastDayOfMonth = nextMonth.subtract(const Duration(days: 1));

    return List<int>.generate(lastDayOfMonth.day, (i) => i + 1);
  }

  Events? getTaskBySpecificDate(int specificDate) {
    // Wait for the tasks list to resolve

    // Format the specific date to 'yyyy-MM-dd' for comparison
    String formattedSpecificDate =
        DateUtil.geFormateDateYYYYMMdd(DateTime(year, month, specificDate));

    // Find the task that matches the specific date

    Events? taskOnSpecificDate;
    try {
      taskOnSpecificDate = tasks.firstWhere(
        (task) =>
            DateUtil.geFormateDateYYYYMMdd(task.date!) == formattedSpecificDate,
      );
    } catch (e) {
      taskOnSpecificDate =
          null; // Handle the error, e.g., return null or take some action
    }
    return taskOnSpecificDate;
  }

  void _loadTasksFromDB() async {
    _tasks = await _dbHelper.getEventsByMonth(year, month);
    notifyListeners();
  }

  void addTask(Events event, int selectedDay) async {
    final date = DateTime(
        year, month, selectedDay, selectedTime.hour, selectedTime.minute);
    event.date = date;
    event.id = event.id ?? DateUtil.getDateTimEStamp(date);
    await _dbHelper.insertEvents(event);
    _loadTasksFromDB(); // Reload tasks after insertion
  }

  void editTask(int id, Events newEvents) async {
    await _dbHelper.updateEvents(newEvents);
    _loadTasksFromDB(); // Reload tasks after update
  }
}
