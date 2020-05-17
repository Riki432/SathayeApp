import 'package:Sathaye/CreateMessage.dart';
import 'package:Sathaye/MessageBox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';

import 'State.dart';

class MessageBoard extends StatefulWidget {
  @override
  _MessageBoardState createState() => _MessageBoardState();
}

class _MessageBoardState extends State<MessageBoard> {
  @override
  Widget build(BuildContext context) {
    ScreenScaler _scale = ScreenScaler()..init(context);
    return Scaffold(
      floatingActionButton: 
        AppState.isAdmin? 
        FloatingActionButton(
          onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CreateMessage()));
          },          
          child: Icon(Icons.add),
          backgroundColor: Colors.deepPurple,
        ) :
        Container(),
      
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height, //_scale.getHeight(90),
        color: Color.fromRGBO(42, 103, 88, 1),
        child: StreamBuilder(
          stream: AppState.isAdmin? 
                  Firestore.instance.collection("Messages").orderBy("TimeStamp", descending: true).snapshots() : 
                  Firestore.instance.collection("Messages").orderBy("TimeStamp", descending: true).where("Department", whereIn: ["All", AppState.department]).snapshots(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              final List docs = snapshot.data.documents;
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (_, i) => MessageBox(
                  department: docs[i].data["Department"],
                  author: docs[i].data["Author"],
                  message: docs[i].data["Message"],
                  timestamp: docs[i].data["TimeStamp"],
                  uid: docs[i].documentID,
                  canDelete: docs[i].data["AuthorUID"] == AppState.uid,
                ),
              );
            }
            else{
              return Center(child: CircularProgressIndicator(backgroundColor: Colors.deepPurple));
            }
          },
        ) 
      ),
    );
  }
}
