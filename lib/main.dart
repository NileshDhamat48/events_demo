
import 'package:demo/feature/event/list/event_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/strings.dart';
import 'feature/provider/event_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<EventProvider>(
            create: (context) => EventProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Strings.eventCalenderLabel,
      home: EventList(), // Main screen
    );
  }
}