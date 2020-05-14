import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';

class MessageBox extends StatelessWidget {
  /// The name of the person that created this message
  final String author;

  // UID of the message, this is useful for deleting it.
  final String uid; 

  // Flag that indicates whether the current user can delete the message or not.
  final bool canDelete;

  ///The contents of the message
  final String message;

  ///The timestamp of the message
  final Timestamp timestamp;

  const MessageBox({Key key, @required this.author, @required this.message, @required this.timestamp, this.uid, this.canDelete = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenScaler _scale = ScreenScaler()..init(context);
    String datetime = "${timestamp.toDate().day}/${timestamp.toDate().month}/${timestamp.toDate().year} ${timestamp.toDate().hour}:${timestamp.toDate().minute}";
    return Padding(
      padding: _scale.getPaddingAll(10),
      child: Container(
        width: _scale.getWidth(60),
        child: GestureDetector(
          onLongPress: !canDelete? null : () async {
            final delete = await showDialog(
              context: context,
              builder: (_) => AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                title: Text("Confirmation"),
                content: Text("Are you sure you want to delete this message?"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("No"),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  FlatButton(
                    child: Text("Yes"),
                    onPressed: () => Navigator.of(context).pop(true),
                  )
                ],
              )
            );

            if(delete == true) 
              Firestore.instance.collection("Messages").document(uid).delete();
          },
            child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: _scale.getPaddingAll(7),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(author, style: TextStyle( fontWeight: FontWeight.w300),)
                  ),
                  
                  Divider(),

                  Text(message),
                  
                  Divider(),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(datetime, style: TextStyle( fontWeight: FontWeight.w300))
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}