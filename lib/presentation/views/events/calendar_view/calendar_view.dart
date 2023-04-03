import 'package:event_app/configs/front_end_configs.dart';
import 'package:event_app/infrastructure/models/event.dart';
import 'package:event_app/infrastructure/services/event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../application/user_provider.dart';

class EventCalendarView extends StatefulWidget {
  const EventCalendarView({Key? key}) : super(key: key);

  @override
  State<EventCalendarView> createState() => _EventCalendarViewState();
}

class _EventCalendarViewState extends State<EventCalendarView> {
  final List<Meeting> meetings = <Meeting>[];

  List<Meeting> _getDataSource(List<EventModel> list) {
    final DateTime today = DateTime.now();
    final DateTime startTime =
        DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    list.map((e) {
      meetings.add(Meeting(
          "Event Name : ${e.title.toString()}",
          e.date!.toDate(),
          e.date!.toDate().add(Duration(minutes: 30)),
          FrontendConfigs.kPrimaryColor,
          false));
    }).toList();
    setState(() {});
    return meetings;
  }

  @override
  void initState() {
    var user = Provider.of<UserProvider>(context, listen: false);
    EventServices()
        .streamEvents(user.getUserDetails()!.docId.toString())
        .first
        .then((value) {
      _getDataSource(value);
    });
    super.initState();
  }

  CalendarView _view = CalendarView.day;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Text("Daily View")),
              Tab(icon: Text("Weekly View")),
              Tab(icon: Text("Monthly View")),
            ],
          ),
          title: Text('Calendar'),
        ),
        body: TabBarView(
          children: [
            SfCalendar(
              view: CalendarView.day,
              todayHighlightColor: FrontendConfigs.kPrimaryColor,
              dataSource: MeetingDataSource(meetings),
              monthViewSettings: MonthViewSettings(
                  appointmentDisplayMode:
                      MonthAppointmentDisplayMode.appointment),
            ),
            SfCalendar(
              view: CalendarView.week,
              todayHighlightColor: FrontendConfigs.kPrimaryColor,
              dataSource: MeetingDataSource(meetings),
              monthViewSettings: MonthViewSettings(
                  appointmentDisplayMode:
                      MonthAppointmentDisplayMode.appointment),
            ),
            SfCalendar(
              view: CalendarView.month,
              todayHighlightColor: FrontendConfigs.kPrimaryColor,
              dataSource: MeetingDataSource(meetings),
              monthViewSettings: MonthViewSettings(
                  appointmentDisplayMode:
                      MonthAppointmentDisplayMode.appointment),
            ),
          ],
        ),
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
