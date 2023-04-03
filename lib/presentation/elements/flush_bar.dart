import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

getFlushBar(
  BuildContext context, {
  required String title,
}) {
  return Flushbar(
    message: title,
    icon: const Icon(
      Icons.info_outline,
      size: 28.0,
      color: Colors.blue,
    ),
    margin: const EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(8),
    duration: const Duration(seconds: 3),
  )..show(context);
}
