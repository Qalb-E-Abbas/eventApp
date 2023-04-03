import 'package:event_app/infrastructure/models/event.dart';
import 'package:event_app/presentation/views/events/create_events/create_event_view.dart';
import 'package:flutter/material.dart';

import '../calendar_view/calendar_view.dart';
import 'layout/body.dart';

class DisplayEventView extends StatelessWidget {
  const DisplayEventView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Events"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EventCalendarView()));
              },
              icon: Icon(Icons.calendar_month))
        ],
      ),
      body: DisplayEventViewBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateEventView(
                        model: EventModel(),
                        isUpdateMode: false,
                      )));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
