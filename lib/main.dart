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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
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
  // await FirebaseAuth.instance.signOut();
  final user = await FirebaseAuth.instance.currentUser();

  if(user != null){
    if(user.email != null && user.email.isNotEmpty){
      AppState.loadAdminState(user);
    }
    else{
    final document = await Firestore.instance.collection("Students").document(user.uid).get();
    AppState.loadState(document);
    }
    Navigator.of(context).pushReplacementNamed("Home");
    Toast.show("Hello, ${AppState.firstName}!", context, duration: Toast.LENGTH_LONG);
  }
  else{
    Navigator.of(context).pushReplacementNamed("Login");
  }
}
