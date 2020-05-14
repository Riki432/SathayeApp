import 'package:Sathaye/Home.dart';
import 'package:Sathaye/LoadingPopup.dart';
import 'package:Sathaye/MessagePopup.dart';
import 'package:Sathaye/Registration.dart';
import 'package:Sathaye/State.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  /// Manages the state of the form, useful in validation
  final _formKey = GlobalKey<FormState>();

  /// Manages the text inside the Phone Field
  final _idController = TextEditingController();

  ///Manages the text inside the Password Field
  final _passwordController = TextEditingController();

  /// Manages the visibility of password field
  bool passwordVisible = false;


  //Manages the toggle button handling Student or Admin
  List<bool> _selected = [true, false];


  @override
  Widget build(BuildContext context) {
    
    ScreenScaler scale = ScreenScaler()..init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Sathaye"),
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: scale.getPaddingAll(15),
            child: Container(
              child: Hero(tag: "Logo", child: Image.asset("assets/logo.jpg"))
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: scale.getPadding(0.5, 3), 
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: _selected[0]? "Phone No." : "Email ID",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                      )
                    ),
                    controller: _idController,
                    maxLength: _selected[0]? 10 : null,
                    keyboardType: _selected[0]? TextInputType.phone : TextInputType.emailAddress,
                    /// if the phone number is not equal to 10 numeric characters return error
                    validator: (val){
                      if(_selected[0]){
                        final pattern = RegExp(r'[0-9]{10}'); 
                        return pattern.hasMatch(val) ? null : "Please enter a valid Phone No.";
                      }
                      else{
                        final pattern = RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");
                        return pattern.hasMatch(val) ? null : "Please enter a valid Email ID";
                      }
                        
                    }
                  ),
                ),


                Padding(
                  padding: scale.getPadding(0.5, 3),
                  child: AnimatedOpacity(
                      curve: Curves.bounceInOut,
                      duration: Duration(milliseconds: 500),
                      opacity: _selected[1]? 1: 0,
                      child: TextFormField(
                      enabled: _selected[1],
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          padding: scale.getPadding(0, 3),
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
                      controller: _passwordController,
                      obscureText: !passwordVisible,
                      /// If the password is empty return or less than 8 characters an error
                      validator: (val) => val.isEmpty || val.length >= 8 ? null : "Please enter a valid password"
                    ),
                  ),
                )
              ],
            ),
          ),

          ToggleButtons(
                borderWidth: 0,
                renderBorder: false,
                color: Colors.grey,
                selectedColor: Colors.deepPurple,
                // disabledColor: MyColorPalette.deepgreen,
                fillColor: Colors.transparent,
                isSelected: _selected,
                onPressed: (index){
                  setState(() {
                    if(index == 0){
                      _selected[0] = true;
                      _selected[1] = false;
                      _idController.clear();
                      AppState.isAdmin = false;
                    }
                    else{
                      _selected[0] = false;
                      _selected[1] = true;
                      _idController.clear();
                      AppState.isAdmin = true;
                    }
                  });
                },
                children: <Widget>[
                  Padding(
                    padding: scale.getPadding(1, 2),
                    child: Text("Student"),
                  ),

                  Padding(
                    padding: scale.getPadding(1, 2),
                    child: Text("Admin"),
                  )
                  
                ],
              ),
          RaisedButton(
            child: Text("Login", style: TextStyle(color: Colors.white, fontSize: scale.getTextSize(11))),
            color: Colors.deepPurple,
            padding: scale.getPadding(0.5, 3),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onPressed: () async {
              if(!_formKey.currentState.validate()) return;
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => LoadingPopup(),
              );
              
              final _auth = FirebaseAuth.instance;
              if(_selected[1]){
                AuthResult result;
                try{
                  result = await _auth.signInWithEmailAndPassword(email: _idController.text.trim(), password: _passwordController.text.trim());
                  final user = result.user;
                  AppState.name = user.displayName;
                  AppState.firstName = user.displayName.split(" ")[0];
                  AppState.lastName = user.displayName.split(" ")[1];
                  AppState.isAdmin = true;
                  AppState.uid = user.uid;

                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => Home()), 
                    ModalRoute.withName("Login")
                  );
                }
                catch(err){
                  Navigator.of(context).pop();
                  print(err);
                  showDialog(
                    context: context,
                    builder: (_) => MessagePopup(child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Icon(Icons.error, color: Colors.red),
                        ),
                        Text("Please check the credentials \n you have entered"),
                      ],
                    ))
                  );
                  return;
                }
                
              }
              else{
              
                _auth.verifyPhoneNumber(
                  phoneNumber: "+91" + _idController.text, 
                  timeout: Duration(seconds: 60),
                  codeAutoRetrievalTimeout: (String verificationId) { 
                    print("Code retrieval timeout");
                   },
                  codeSent: (String verificationId, [int forceResendingToken]) async { 
                    print("Code sent verification ID: $verificationId");
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

                            final authCred = PhoneAuthProvider.getCredential(
                              verificationId: verificationId,
                              smsCode: otp
                            );

                            final result = await _auth.signInWithCredential(authCred);
                            final doc = await Firestore.instance.collection("Students").document(result.user.uid).get();
                            
                            //Making sure the user has registered before they login.
                            if(!doc.exists){
                              showDialog(
                                context: context,
                                builder: (_) => MessagePopup(
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: Icon(Icons.error, color: Colors.red),
                                      ),
                                      Text("Please register before you login."),
                                    ],
                                  ),
                                )
                              );
                              result.user.delete();
                              Navigator.of(context).pop(); // Removing the loading screen.
                              return;
                            }
                            

                            AppState.firstName = doc.data["FirstName"];
                            AppState.lastName = doc.data["LastName"];
                            AppState.phone = doc.data["Phone"];
                            AppState.isAdmin = false;
                            AppState.department = doc.data["Department"];
                            AppState.uid = result.user.uid;

                            Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => Home(),
                            )
                          ); 
                  },
                  verificationCompleted: (AuthCredential phoneAuthCredential) async { 
                  /// This is for the case when we auto retrieve the OTP and user doesn't have to be involved in anyway.
                  final result =  await _auth.signInWithCredential(phoneAuthCredential);
                  
                  /// Fetch the document from the data base, if the document does not exist that means the user
                  /// Has tried to log in without registering first.
                  /// Since we need to know which department they belong to that cannot be allowed 
                  /// so we display an error message and delete the user.
                  
                  final doc = await Firestore.instance.collection("Students").document(result.user.uid).get();
                  if(!doc.exists){
                    showDialog(
                      context: context,
                      builder: (_) => MessagePopup(
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Icon(Icons.error, color: Colors.red),
                            ),
                            Text("Please register before you try login."),
                          ],
                        ),
                      )
                    );
                    result.user.delete();
                    return;
                  }

                  AppState.firstName = doc.data["FirstName"];
                  AppState.lastName = doc.data["LastName"];
                  AppState.phone = doc.data["Phone"];
                  AppState.department = doc.data["Department"];
                  AppState.uid = doc.documentID;
                  AppState.isAdmin = false;

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => Home(),
                    )
                  ); 
                  },
                  verificationFailed: (AuthException error) { 
                    Navigator.of(context).pop();
                    showDialog(
                    context: context,
                    builder: (_) => MessagePopup(child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Icon(Icons.error, color: Colors.red),
                        ),
                        Text("Something went wrong")
                      ],
                    ))
                  );
                  }, 
                );
              }
            
              print("Login button pressed");
            },
          ),
          Spacer(),
          Container(
            color: Colors.deepPurple,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Not registered yet?  ", style: TextStyle(color: Colors.white,)),
                FlatButton(
                  child: Text("Register", style: TextStyle(color: Colors.yellowAccent, fontSize: 20)),
                  onPressed: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Registration(),
                      )
                    );
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}