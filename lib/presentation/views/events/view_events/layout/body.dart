import 'package:event_app/application/date_formatter.dart';
import 'package:event_app/application/user_provider.dart';
import 'package:event_app/configs/front_end_configs.dart';
import 'package:event_app/infrastructure/models/event.dart';
import 'package:event_app/presentation/elements/navigation_dialog.dart';
import 'package:event_app/presentation/views/events/create_events/create_event_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../infrastructure/services/event.dart';
import '../../../../elements/processing_widget.dart';

class DisplayEventViewBody extends StatelessWidget {
  const DisplayEventViewBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context);
    return StreamProvider.value(
      value:
          EventServices().streamEvents(user.getUserDetails()!.docId.toString()),
      initialData: [EventModel()],
      builder: (context, child) {
        List<EventModel> _list = context.watch<List<EventModel>>();
        return _list.isNotEmpty
            ? _list[0].docId == null
                ? Center(
                    child: ProcessingWidget(),
                  )
                : ListView.builder(
                    itemCount: _list.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                        leading: CircleAvatar(
                            backgroundColor: FrontendConfigs.kPrimaryColor,
                            child: Icon(
                              Icons.event,
                              size: 14,
                              color: Colors.white,
                            )),
                        isThreeLine: true,
                        title: Text(
                          _list[i].title.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  showNavigationDialog(context,
                                      message:
                                          "Do you really want to delete this event?",
                                      buttonText: "Yes", navigation: () async {
                                    Navigator.pop(context);
                                    await EventServices().deleteEvents(
                                        _list[i].docId.toString());
                                  },
                                      secondButtonText: "No",
                                      showSecondButton: true);
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CreateEventView(
                                                model: _list[i],
                                                isUpdateMode: true,
                                              )));
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                )),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_list[i].description.toString()),
                            Text(DateFormatter.dateFormatter(
                                _list[i].date!.toDate())),
                          ],
                        ),
                      );
                    })
            : Center(child: Text("No Data Found!"));
      },
    );
  }
}
