import 'package:flutter/material.dart';

class LoadingPopup extends StatefulWidget {
  @override
  _LoadingPopupState createState() => _LoadingPopupState();
}

class _LoadingPopupState extends State<LoadingPopup>{
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        contentPadding: EdgeInsets.all(50.0),
        content: Row(
          children: <Widget>[
            Text("Loading"),
            Spacer(),
            CircularProgressIndicator()
          ],
        ),
      );
  }
}