import 'package:flutter/material.dart';

import '../../../../infrastructure/models/event.dart';
import 'layout/body.dart';

class CreateEventView extends StatelessWidget {
  final EventModel model;
  final bool isUpdateMode;

  CreateEventView({Key? key, required this.model, required this.isUpdateMode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Event"),
        centerTitle: true,
      ),
      body: CreateEventViewBody(
        model: model,
        isUpdateMode: isUpdateMode,
      ),
    );
  }
}
