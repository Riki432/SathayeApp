import 'package:Sathaye/About.dart';
import 'package:Sathaye/CreateAdmin.dart';
import 'package:Sathaye/MessageBoard.dart';
import 'package:Sathaye/PrnSheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'State.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{
  TabController _tabController;

  @override
  void initState() { 
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);  
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
        actions: AppState.isAdmin? <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (val){
              if(val == "NEW_USER"){
                print("Requested to create a new user");
                showDialog(
                  context: context,
                  builder: (_) => CreateAdmin()
                );
              }
              else if(val == "SIGN_OUT"){
                print("Signing out");
                FirebaseAuth.instance.signOut();
                Navigator.of(context).popAndPushNamed("Login");
              }
              else if(val == "NEW_PRN"){
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => PRNSheet()));
              }
            },
            itemBuilder: (context) => [
              AppState.isAdmin?
              PopupMenuItem(
                child: Text("Add a new user"),
                value: "NEW_USER",
              ) : null,

              AppState.isAdmin?
              PopupMenuItem(
                child: Text("New PRN"),
                value: "NEW_PRN",
              ) : null,

              PopupMenuItem(
                child: Text("Sign out"),
                value: "SIGN_OUT",
              ),


            ],
          )
        ] : null,
        bottom: TabBar(
          indicatorColor: Colors.deepPurple,
          controller: _tabController,
          labelStyle: TextStyle(fontSize: 15),
          tabs: <Widget>[
            Tab(text: "Messages",),
            Tab(text: "About",),
          ],
        ),
      ),
      body: WillPopScope(
          onWillPop: () => showDialog<bool>(
            context: context,
            builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text("Confirmation"),
              content: Text("Are you sure you want to exit?"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Yes"),
                  onPressed: (){
                    Navigator.of(context).pop(true);
                  },
                ),
                FlatButton(
                  child: Text("No"),
                  onPressed: (){
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            )
          ),
          child: TabBarView(
          controller: _tabController,
          children: <Widget>[
            MessageBoard(),
            About()
          ],
        ),
      )
    );
  }
}