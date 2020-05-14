import 'package:Sathaye/Login.dart';
import 'package:Sathaye/Registration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toast/toast.dart';

import 'Home.dart';
import 'State.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.deepPurple,
      ),
      routes: {
        "Login" : (context) => Login(),
        "Registration" : (context) => Registration(),
        "Home" : (context) => Home()
      },
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    directLogin(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Sathaye"),
      ),
      body: Center(
        child: Hero(tag: "Logo", child: Image.asset("assets/logo.jpg"))
      )
    ); 
  }
}


Future<void> directLogin(context) async{
  final user = await FirebaseAuth.instance.currentUser();
  if(user != null){
    if(user.email != null || user.email.isNotEmpty){
      AppState.name      = user.displayName;
      AppState.firstName = user.displayName.split(" ")[0];
      AppState.lastName  = user.displayName.split(" ")[1];
      AppState.isAdmin   = true;
      AppState.uid       = user.uid;
    }
    else{
    final document = await Firestore.instance.collection("Students").document(user.uid).get();
    AppState.firstName  = document.data["FirstName"];
    AppState.lastName   = document.data["LastName"];
    AppState.phone      = document.data["Phone"];
    AppState.department = document.data["Department"];
    AppState.isAdmin    = false;
    AppState.uid        = user.uid;
    }
    Navigator.of(context).pushReplacementNamed("Home");
    Toast.show("Hello, ${AppState.firstName}!", context, duration: Toast.LENGTH_LONG);
  }
  else{
    Navigator.of(context).pushReplacementNamed("Login");
  }
}
