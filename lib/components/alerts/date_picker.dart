import 'package:flutter/material.dart';

void showDefaultDatePicker(BuildContext context) => showDatePicker(
  context: context,
  initialDate: DateTime.now(),
  firstDate: DateTime.now(),
  lastDate: DateTime.now().add(const Duration(days: 60)),
);