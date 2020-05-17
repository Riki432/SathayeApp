import 'dart:async';

import 'package:Sathaye/Departments.dart';
import 'package:Sathaye/State.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toast/toast.dart';

import 'Home.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  /// Manages the registration form state. Useful for validation.
  final _formKey = GlobalKey<FormState>();

  /// Used to show snackbar for wrong PRN number.
  final scaffoldKey = GlobalKey<ScaffoldState>();

  /// Manages the PRN number field.
  final prnController = TextEditingController();

  /// Manages the first name field.
  final firstNameController = TextEditingController();

  /// Manages the last name field.
  final lastNameController = TextEditingController();

  /// Manages the department field.
  String department;

  /// Manages the year field.
  String year;

  /// Manages the Phone No. field.
  final phoneController = TextEditingController();

  ///Manages the UUID field
  final uidController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final scale = ScreenScaler()..init(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Registration"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
          child: Form(
          key: _formKey,
          child: Container(
            margin: scale.getMargin(5, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[    
                TextFormField(
                  maxLength: 16,
                  controller: prnController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "PRN No.",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                  validator: (val) => RegExp(r'[0-9]{16}').hasMatch(val)
                      ? null
                      : "Please check the PRN number",
                ),

                Padding(
                  padding: scale.getPadding(1, 0),
                  child: TextFormField(
                    maxLength: 6,
                    controller: uidController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "UUID",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                    validator: (val) => RegExp(r'[0-9]{6}').hasMatch(val)
                        ? null
                        : "Please check the UUID number",
                  ),
                ),
                
                Padding(
                  padding: scale.getPadding(1, 0),
                  child: TextFormField(
                    controller: firstNameController,
                    decoration: InputDecoration(
                      labelText: "First Name",
                        border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                      )
                    ),
                    validator: (val) =>
                        val.isNotEmpty ? null : "Cannot be empty",
                  ),
                ),

                Padding(
                  padding: scale.getPadding(1, 0),
                  child: TextFormField(
                    controller: lastNameController,
                    decoration: InputDecoration(
                      labelText: "Last Name",
                        border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                      )
                    ),
                    validator: (val) =>
                        val.isNotEmpty ? null : "Cannot be empty",
                  ),
                ),

                Padding(
                  padding: scale.getPadding(1, 0),
                  child: TextFormField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: "Phone No.",
                        border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                      )
                    ),
                    validator: (val) =>
                        RegExp(r'[0-9]{10}').hasMatch(val) ? null : "Please enter a valid phone number.",
                  ),
                ),

 
                Padding(
                  padding: scale.getPadding(1, 0),
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: "Department",
                        border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                    ),
                    items: departments
                        .map((department) => DropdownMenuItem(
                              child: Text(department),
                              value: department,
                            ))
                        .toList(),
                    onChanged: (value) {
                      department = value;
                    },
                    validator: (value) => departments.contains(value) ? null : "Please enter a valid value"
                  ),
                ),

                Padding(
                  padding: scale.getPadding(1, 0),
                  child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: "Current Year",
                          border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)
                        ),
                      ),
                    items: ["F.Y", "S.Y.", "T.Y."]
                        .map((department) => DropdownMenuItem(
                              child: Text(department),
                              value: department,
                            ))
                        .toList(),
                    onChanged: (value) {
                      year = value;
                    },
                    validator: (value) => ["F.Y", "S.Y.", "T.Y."].contains(value) ? null : "Please enter a valid value"
                  ),
                ),

                

                Padding(
                  padding: scale.getPadding(1, 0),
                  child: Align(
                    alignment: Alignment.center,
                    child: RaisedButton(
                      child: Text("Register", style: TextStyle(color: Colors.white, fontSize: scale.getTextSize(11))),
                      color: Colors.deepPurple,
                      padding: scale.getPadding(0.5, 3), 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      onPressed: () async { 
                        if(!_formKey.currentState.validate()) return;
                        final prn = prnController.text;
                        final _auth = FirebaseAuth.instance;
                        final _firestore = Firestore.instance;
                        /// Check the PRN collection if there is a record for the mentioned PRN
                        final doc = await _firestore.collection("PRNs").document(prn).get();
                        
                        /// If the record does not exist, shwo error and return
                        if(!doc.exists){

                          /// To Do Show a toast message or snackbar notifying that the user is not a valid user
                          scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Not a valid PRN No.", style: TextStyle(color: Colors.yellowAccent),)));
                          return;
                        }

                        String _verificationId;

                        /// If the record does exist, we go forward to create a new user
                        _auth.verifyPhoneNumber(
                          codeAutoRetrievalTimeout: (String verificationId) {  }, 
                          codeSent: (String verificationId, [int forceResendingToken]) { 
                            _verificationId = verificationId;
                           }, 
                          phoneNumber: "+91" + phoneController.text, /// because we are only expecting students from India. 
                          timeout: Duration(seconds: 60), 
                          verificationCompleted: (AuthCredential phoneAuthCredential) async {
                            final result = await _auth.signInWithCredential(phoneAuthCredential);

                            _firestore.collection("Students").document(result.user.uid).setData({
                              "Name" : firstNameController.text + " " + lastNameController.text,
                              "Phone" : phoneController.text,
                              "Department" : department,
                              "Year" : year,
                              "PRN" : prn,
                              "UUID" : uidController.text
                            });

                            AppState.prn = prnController.text;
                            AppState.firstName = firstNameController.text;
                            AppState.lastName = lastNameController.text;
                            AppState.phone = phoneController.text;
                            AppState.department = department;
                            AppState.year = year;
                            AppState.isAdmin = false;
                      
                            Toast.show("Welcome, ${firstNameController.text}!", context, duration: Toast.LENGTH_LONG);
                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => Home()), ModalRoute.withName("/"));
                          }, 
                          verificationFailed: (AuthException error) { 
                            Toast.show("Something went wrong", context);
                          }
                        );
                                              
                        

                            /// Get the OTP from user.
                        final otp = await showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) {
                              TextEditingController otpController = TextEditingController();
                              return StatefulBuilder(
                                  builder: (context, setState) {
                                return AlertDialog(
                                  title: ListTile(
                                    title: Text(
                                      "Enter your OTP",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    leading: Icon(Icons.mail),
                                  ),
                                  contentPadding: EdgeInsets.all(20.0),
                                  content: TextField(
                                    controller: otpController,
                                    keyboardType: TextInputType.number,
                                    maxLength: 6,
                                    decoration: InputDecoration(
                                        hintText: "OTP here", 
                                        border: OutlineInputBorder()
                                      ),
                                    ),
                                  elevation: 15.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0)
                                    ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("Submit"),
                                      onPressed: () {
                                        Navigator.of(context).pop(otpController.text);
                                      },
                                    )
                                  ],
                                );
                              });
                            });
                        
                        final phoneAuthCred = PhoneAuthProvider.getCredential(
                          verificationId: _verificationId,
                          smsCode: otp
                        );

                        final authResult = await _auth.signInWithCredential(phoneAuthCred);

                        final user = authResult.user;

                        user.getIdToken(refresh: true);

                        _firestore.collection("Students").document(user.uid).setData({
                          "Name" : firstNameController.text + " " + lastNameController.text,
                          "Phone" : phoneController.text,
                          "Department" : department,
                          "Year" : year,
                          "PRN" : prn,
                          "UUID" : uidController.text
                        });

                        AppState.firstName = firstNameController.text;
                        AppState.lastName = lastNameController.text;
                        AppState.department = department;
                        AppState.year = year;
                        AppState.isAdmin = false;
                        
                        Toast.show("Welcome, ${firstNameController.text}!", context, duration: Toast.LENGTH_LONG);
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => Home()), ModalRoute.withName("/"));
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
