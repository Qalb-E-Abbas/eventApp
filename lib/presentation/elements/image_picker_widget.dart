import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:event_app/application/date_formatter.dart';
import 'package:event_app/configs/front_end_configs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DatePickerWidget extends StatelessWidget {
  final DateTime? dateTime;
  final String? label;
  final VoidCallback onTap;

  DatePickerWidget(
      {required this.dateTime, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: Radius.circular(8),
      color: FrontendConfigs.kPrimaryColor,
      dashPattern: [7, 9],
      child: Container(
        height: 60,
        child: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(dateTime == null
                  ? "Select Date"
                  : DateFormatter.dateFormatter(dateTime!)),
              IconButton(
                onPressed: () => onTap(),
                icon: Icon(
                  CupertinoIcons.clock,
                  color: FrontendConfigs.kPrimaryColor,
                  size: 25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
