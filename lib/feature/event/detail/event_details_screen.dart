import 'package:demo/data/model/event_model.dart';
import 'package:demo/feature/provider/event_provider.dart';
import 'package:demo/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/strings.dart';

class EventDetailsScreen extends StatefulWidget {
  final Events? events;
  final int date;

  const EventDetailsScreen({super.key, this.events, required this.date});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    prefillData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildMainContent(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xff015493),
      leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Center(
              child: Text(
            Strings.onPopBackText,
            style: TextStyle(color: Colors.white),
          ))),
      title: const Text(
        Strings.eventsDetailsTitle,
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
    );
  }

  Widget buildMainContent() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  buildTimeRow(),
                  const SizedBox(
                    height: 20,
                  ),
                  buildTitleRow(),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(Strings.descriptionLabel),
                  buildDescription(),
                  const Spacer(),
                  buildSubmitButton(),
                ],
              ),
            )),
      ],
    );
  }

  Widget buildTimeRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(flex: 1, child: Text(Strings.dateAndTimeLabel)),
        Expanded(
            flex: 2,
            child: Consumer<EventProvider>(
                builder: (context, eventProvider, child) {
              return Row(
                children: [
                  GestureDetector(
                    onTap: _selectTime,
                    child: Container(
                      height: 40,
                      width: 60,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          border: Border.all(color: Colors.grey)),
                      child: Center(child: Text(eventProvider.formatedTime)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                        '${widget.date}-${DateUtil.getMonthName(eventProvider.month)}-${eventProvider.year}'),
                  )
                ],
              );
            }))
      ],
    );
  }

  Widget buildTitleRow() {
    return Row(
      children: [
        const Expanded(flex: 1, child: Text(Strings.titleLabel)),
        Expanded(
            flex: 2,
            child: TextField(
              controller: titleController,
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                ),
                hintText: Strings.titleLabel,
              ),
            )),
      ],
    );
  }

  Widget buildDescription() {
    return TextField(
      controller: descriptionController,
      maxLines: 4,
      decoration: InputDecoration(
        fillColor: Colors.grey[300], // Set your desired background color here
        filled: true, // Make sure the background color is applied
        border: InputBorder.none, // Remove the border
        hintText: 'Enter Description', // Update with your hint text
      ),
      style: const TextStyle(
        color: Colors.black, // Text color (optional)
      ),
    );
  }

  Widget buildSubmitButton() => GestureDetector(
        onTap: submitTask,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          width: double.infinity,
          height: 50,
          color: const Color(0xff015493),
          child: const Center(
              child: Text(Strings.buttonSaveText,
                  style: TextStyle(
                    color: Colors.white,
                  ))),
        ),
      );

  void submitTask() {
    if (titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
      Events event = widget.events ?? Events();
      event.title = titleController.text;
      event.description = descriptionController.text;

      Provider.of<EventProvider>(context, listen: false)
          .addTask(event, widget.date);
      Navigator.of(context).pop();
    }
  }

  void prefillData() {
    titleController = TextEditingController(text: widget.events?.title);
    descriptionController =
        TextEditingController(text: widget.events?.description);

    if (widget.events?.date != null) {
      Provider.of<EventProvider>(context, listen: false).updateTime(
          DateUtil.convertDateTimeToTimeOfDay(widget.events!.date!),
          notify: false);
    }
  }

  void _selectTime() async {
    var selectedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    if (selectedTime != null) {
      Provider.of<EventProvider>(context, listen: false)
          .updateTime(selectedTime);
    }
  }
}
