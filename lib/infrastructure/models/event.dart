// To parse this JSON data, do
//
//     final eventModel = eventModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';


class EventModel {
  EventModel({
    this.docId,
    this.userID,
    this.title,
    this.description,
    this.date,
  });

  String? docId;
  String? userID;
  String? title;
  String? description;
  Timestamp? date;

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        docId: json["docID"],
        title: json["title"],
    userID: json["userID"],
        description: json["description"],
        date: json["date"],
      );

  Map<String, dynamic> toJson(String docID) => {
        "docID": docID,
        "userID": userID,
        "title": title,
        "description": description,
        "date": date,
      };
}
