import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_app/application/date_formatter.dart';
import 'package:event_app/application/user_provider.dart';
import 'package:event_app/infrastructure/models/event.dart';
import 'package:event_app/infrastructure/services/event.dart';
import 'package:event_app/presentation/elements/app_button.dart';
import 'package:event_app/presentation/elements/auth_field.dart';
import 'package:event_app/presentation/elements/flush_bar.dart';
import 'package:event_app/presentation/elements/image_picker_widget.dart';
import 'package:event_app/presentation/elements/navigation_dialog.dart';
import 'package:event_app/presentation/elements/processing_widget.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class CreateEventViewBody extends StatefulWidget {
  final EventModel model;
  final bool isUpdateMode;

  CreateEventViewBody(
      {Key? key, required this.model, required this.isUpdateMode})
      : super(key: key);

  @override
  State<CreateEventViewBody> createState() => _CreateEventViewBodyState();
}

class _CreateEventViewBodyState extends State<CreateEventViewBody> {
  TextEditingController _titleController = TextEditingController();

  TextEditingController _descriptionController = TextEditingController();

  bool isLoading = false;

  DateTime? selectedDate;

  DateTime? date = DateTime.now();

  @override
  void initState() {
    if (widget.isUpdateMode == true) {
      _titleController =
          TextEditingController(text: widget.model.title.toString());
      _descriptionController =
          TextEditingController(text: widget.model.description.toString());
      selectedDate = widget.model.date!.toDate();
      setState(() {});
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context);
    return LoadingOverlay(
      isLoading: isLoading,
      color: Colors.transparent,
      progressIndicator: ProcessingWidget(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            CustomTextField(
              text: "Title",
              onTap: () {},
              keyBoardType: TextInputType.name,
              controller: _titleController,
            ),
            SizedBox(
              height: 20,
            ),
            CustomTextField(
              text: "Description",
              onTap: () {},
              keyBoardType: TextInputType.name,
              controller: _descriptionController,
            ),
            SizedBox(
              height: 20,
            ),
            DatePickerWidget(
                dateTime: selectedDate,
                label: "Pick Date",
                onTap: () {
                  _selectDate(context);
                }),
            SizedBox(
              height: 60,
            ),
            AppButton(
                onPressed: () {
                  isLoading = true;
                  setState(() {});
                  if (widget.isUpdateMode == true) {
                    EventServices()
                        .updateEvents(EventModel(
                            docId: widget.model.docId.toString(),
                            title: _titleController.text,
                            description: _descriptionController.text,
                            userID: user.getUserDetails()!.docId.toString(),
                            date: Timestamp.fromDate(selectedDate!)))
                        .then((value) {
                      isLoading = false;
                      setState(() {});
                      showNavigationDialog(context,
                          message: "Event has been updated successfully.",
                          buttonText: "Okay", navigation: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                          secondButtonText: "secondButtonText",
                          showSecondButton: false);
                    }).onError((error, stackTrace) {
                      isLoading = false;
                      setState(() {});
                      getFlushBar(context,
                          title: "An undefined error occurred.");
                    });
                  } else {
                    EventServices()
                        .createEvent(context,
                            model: EventModel(
                                title: _titleController.text,
                                description: _descriptionController.text,
                                userID: user.getUserDetails()!.docId.toString(),
                                date: Timestamp.fromDate(selectedDate!)))
                        .then((value) {
                      isLoading = false;
                      setState(() {});
                      showNavigationDialog(context,
                          message: "Event has been added successfully.",
                          buttonText: "Okay", navigation: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                          secondButtonText: "secondButtonText",
                          showSecondButton: false);
                    }).onError((error, stackTrace) {
                      isLoading = false;
                      setState(() {});
                      getFlushBar(context,
                          title: "An undefined error occurred.");
                    });
                  }
                },
                btnLabel: "Create Event"),
          ],
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    selectedDate = await showDatePicker(
      context: context,
      initialDate: date!,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (selectedDate != null && selectedDate != date)
      setState(() {
        date = selectedDate;
      });
  }
}
