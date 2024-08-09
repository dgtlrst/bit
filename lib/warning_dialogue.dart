import 'package:bit/State_app.dart';
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
        title: Text('Warning'),
        content: Column(
          children: [
            Text(explanation),
            Text('Are you sure you want to proceed?')
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              onCancel();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Accept'),
            onPressed: () {
              onAccept();
              // Add your accept action here
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Accept and never warn again! Placeholder!'),
            onPressed: () {
              state.globalSettings.warnings = false;
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
