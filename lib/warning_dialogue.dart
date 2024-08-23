import 'package:bit/state_app.dart';
import 'package:flutter/material.dart';

void showWarningDialog(
    {required AppState state,
    required BuildContext context,
    required void Function() onAccept,
    required void Function() onCancel,
    required String explanation}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Warning'),
        content: Column(
          children: [
            Text(explanation),
            const Text('Are you sure you want to proceed?')
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              onCancel();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Accept'),
            onPressed: () {
              onAccept();
              // Add your accept action here
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Accept and never warn again! Placeholder!'),
            onPressed: () {
              state.globalSettings.setWarnings(false);
              onAccept();
              // Add your accept action here
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
