import 'package:Sathaye/Departments.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:toast/toast.dart';

import 'State.dart';

class CreateMessage extends StatefulWidget {
  @override
  _CreateMessageState createState() => _CreateMessageState();
}

class _CreateMessageState extends State<CreateMessage> {
  // Manages the text inside the message text field
  TextEditingController messageController = TextEditingController();

  // Contains the current selected department to send message to.
  String department = "All";

  @override
  Widget build(BuildContext context) {
    ScreenScaler _scale = ScreenScaler()..init(context);
    final List<String> _departments = ["All"] + departments;
    return Scaffold(
      appBar: AppBar(
        title: Text("New Message :"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: _scale.getPadding(1, 5),
              child: DropdownButton(
                hint: Text(department),
                onChanged: (val){
                  setState(() {
                    department = val;  
                  });
                  print(department);
                },
                items: _departments.map((department) => DropdownMenuItem(
                  child: Text(department),
                  value: department,
                )).toList(),
              ),
            ),
          ),
          Padding(
            padding: _scale.getPaddingAll(10),
            child: TextField(
              controller: messageController,
              minLines: 1,
              maxLines: 20,
              maxLength: 1000,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  gapPadding: 10
                )
              ),
            ),
          ),

          RaisedButton(
            child: Text("Send", style: TextStyle(color: Colors.white, fontSize: _scale.getTextSize(11)),),
            padding: _scale.getPadding(1, 2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Colors.deepPurple,
            onPressed: (){
            if(messageController.text.isEmpty){
              Toast.show("Message cannot be empty", context);
              return;
            }

            ///Upload the message to the database
            Firestore.instance.collection("Messages").document().setData({
              "Author"     : AppState.name,
              "Message"    : messageController.text,
              "TimeStamp"  : DateTime.now(),
              "Department" : department,
              "AuthorUID"  : AppState.uid
            });

              print(DateTime.now());
              print(messageController.text);
              print(AppState.firstName + ' ' + AppState.lastName);
              print(department);

              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}