import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:toast/toast.dart';

class CreateAdmin extends StatefulWidget {
  @override
  _CreateAdminState createState() => _CreateAdminState();
}

class _CreateAdminState extends State<CreateAdmin> {
  //Manages the state of the fields in the form. Useful for validation
  final _formKey = GlobalKey<FormState>();

  // Manages the contents of first name field.
  final firstNameController = TextEditingController();
  
  // Manages the contents of last name field.
  final lastNameController = TextEditingController();
  
  // Manages the contents of email field.
  final emailController = TextEditingController();
  
  // Manages the contents of password field.
  final passwordController = TextEditingController();

  //Manages the visibility of password
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    ScreenScaler scale = ScreenScaler()..init(context);
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Container(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children : <Widget>[
              Container(
                width: scale.getWidth(100),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.deepPurple,
                ),
                padding: scale.getPaddingAll(8),
                child: Text("Register new Admin", style: TextStyle(color: Colors.white, fontSize: scale.getTextSize(12))),
              ),
              Padding(
                padding: scale.getPadding(1, 1),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                    )
                  ),
                  validator: (val){
                    final pattern = RegExp(
                        r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");
                    return pattern.hasMatch(val)? null: "Please enter a valid Email ID.";
                  },
                ),
              ),

              Padding(
                padding: scale.getPadding(1, 1),
                child: TextFormField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                    labelText: "First Name",
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                    )
                  ),
                  validator: (val) => val.isNotEmpty? null: "First name cannot be empty",
                ),
              ),
              
              Padding(
                padding: scale.getPadding(1, 1),
                child: TextFormField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                    labelText: "Last Name",
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                    )
                  ),
                  validator: (val) => val.isNotEmpty? null: "Last name cannot be empty",
                ),
              ),

              Padding(
                padding: scale.getPadding(1, 1),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: !passwordVisible,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(Icons.remove_red_eye, color: passwordVisible? Colors.deepPurple : Colors.grey,),
                      onPressed: (){
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    ),
                    labelText: "Password",
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                    )
                  ),
                  validator: (val) => val.length < 8 ? "Password has to be atleast 8 characters long." : null,
                ),
              ),

              Padding(
                padding: scale.getPadding(1, 1),
                child: RaisedButton(
                  color: Colors.deepPurple,
                  padding: scale.getPadding(1, 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  child: Text("Register", style: TextStyle(color: Colors.white, fontSize: scale.getTextSize(10))),
                  onPressed: (){
                    /// This sets off a cloud function which creates an Admin user.
                    Firestore.instance.collection("Admins").document().setData({
                      "Email" : emailController.text.trim(),
                      "FirstName" : firstNameController.text.trim(),
                      "LastName" : lastNameController.text.trim(),
                      "Password" : passwordController.text.trim()
                    });

                    Navigator.of(context).pop();

                    Toast.show("Created a new user : ${firstNameController.text} ${lastNameController.text}", context, duration: Toast.LENGTH_LONG);
                  },
                ),
              )
            ]
          ),
        ),
      ),
    );
  }
}