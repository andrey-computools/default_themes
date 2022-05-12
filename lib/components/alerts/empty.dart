import 'package:flutter/material.dart';

void showEmptyDialog(BuildContext context) => showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: const Text('Пустой диалог'),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Закрыть'),
      ),
    ],
  ),
);