import 'package:flutter/material.dart';

void showDefaultTimePicker(BuildContext context) => showTimePicker(
  context: context,
  initialTime: TimeOfDay.now(),
);