import 'package:demo/data/model/event_model.dart';
import 'package:demo/feature/event/detail/event_details_screen.dart';
import 'package:demo/feature/provider/event_provider.dart';
import 'package:demo/utils/date_utils.dart';
import 'package:demo/widget/dialog/time_picker_dialog.dart';
import 'package:demo/widget/dialog/year_picker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/strings.dart';


class EventList extends StatelessWidget {
  const EventList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildMainContent(),
    );
  }

  // Builds the AppBar
  AppBar buildAppBar() {
    return AppBar(
      title: const Text(
        Strings.homeEventsLabel,
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      backgroundColor: const Color(0xff015493),
    );
  }

  // Builds the main content of the screen
  Widget buildMainContent() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(child: buildYearWidget()),
              // Year picker
              const SizedBox(width: 20),
              Expanded(child: buildMonthWidget()),
              // Month picker
            ],
          ),
        ),
        Expanded(child: buildEventList()),
        // Event list
      ],
    );
  }

  // Widget for selecting the year
  Widget buildYearWidget() {
    return Consumer<EventProvider>(builder: (context, eventProvider, child) {
      return GestureDetector(
        onTap: () => pickYear(context, eventProvider), // Pick year on tap
        child: Container(
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(0xff015493)),
          child: Center(
              child: Text(
            eventProvider.year.toString(),
            style: const TextStyle(color: Colors.white),
          )),
        ),
      );
    });
  }

  // Widget for selecting the month
  Widget buildMonthWidget() {
    return Consumer<EventProvider>(builder: (context, eventProvider, child) {
      return GestureDetector(
        onTap: () => pickMonth(context, eventProvider), // Pick month on tap
        child: Container(
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(0xff015493)),
          child: Center(
            child: Text(
              DateUtil.getMonthName(eventProvider.month),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    });
  }

  // Builds the list of events
  Widget buildEventList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Consumer<EventProvider>(builder: (context, eventProvider, child) {
        return ListView.separated(
          itemCount: eventProvider
              .getDaysInMonth()
              .length, // Get days in selected month
          itemBuilder: (context, index) {
            Events? event = Provider.of<EventProvider>(context, listen: false)
                .getTaskBySpecificDate(index + 1);
            return buildListItem(context, event, index, eventProvider);
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(
              color: Colors.grey,
              height: 2,
            );
          },
        );
      }),
    );
  }

  // Builds each individual event list item
  Widget buildListItem(BuildContext context, Events? event, int index,
      EventProvider eventProvider) {
    return GestureDetector(
        onTap: () {
          navigateToDetailScreen(
              context, event, index); // Navigate to event details
        },
        child: Container(
          color: Colors.transparent,
          child: Row(
            children: [
              Column(
                children: [
                  Text(
                    "${index + 1}", // Display day number
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    DateUtil.getMonthName(eventProvider.month),
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.all(10),
                height: 50,
                width: 2,
                color: Colors.grey,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (event?.date != null)
                    Text(
                      DateUtil.geFormateDateTime(event?.date),
                    ),
                  Text(
                    event?.date != null ? event?.title ?? '' : "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  // Navigate to the event details screen
  void navigateToDetailScreen(BuildContext context, Events? event, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              EventDetailsScreen(events: event, date: index + 1)),
    );
  }

  // Function to pick the month using
  void pickMonth(BuildContext context, EventProvider provider) async {
    int? month = await showCupertinoMonthPicker(context);
    if (month != null) {
      provider.updateMonth(month);
    }
  }

  // Function to pick the year
  void pickYear(BuildContext context, EventProvider provider) async {
    int? year = await showCupertinoYearPicker(context);
    if (year != null) {
      provider.updateYear(year); // Update the year in the provider
    }
  }
}
