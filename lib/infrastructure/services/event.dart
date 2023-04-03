import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_app/infrastructure/models/event.dart';
import 'package:flutter/material.dart';

class EventServices {
  ///Create Event
  Future<void> createEvent(BuildContext context,
      {required EventModel model}) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('eventCollection').doc();
    await docRef.set(model.toJson(docRef.id));
  }

  ///Fetch Events
  Stream<List<EventModel>> streamEvents(String userID) {
    return FirebaseFirestore.instance
        .collection('eventCollection')
        .where('userID', isEqualTo: userID)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => EventModel.fromJson(e.data())).toList());
  }

  ///Delete Events
  Future deleteEvents(String eventID) {
    return FirebaseFirestore.instance
        .collection('eventCollection')
        .doc(eventID)
        .delete();
  }

  ///Update Events
  Future<void> updateEvents(EventModel model) async {
    return await FirebaseFirestore.instance
        .collection('eventCollection')
        .doc(model.docId.toString())
        .update({
      "title": model.title.toString(),
      "description": model.description.toString(),
      "date": model.date,
    });
  }
}
