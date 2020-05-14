import 'package:flutter/material.dart';

class MessagePopup extends StatelessWidget {
  final Widget child;

  const MessagePopup({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        contentPadding: EdgeInsets.all(30.0),
        content: child,
      );
  }
}