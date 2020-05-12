import 'package:Sathaye/Registration.dart';
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
  final _phoneController = TextEditingController();

  ///Manages the text inside the Password Field
  final _passwordController = TextEditingController();

  /// Manages the visibility of password field
  bool passwordVisible = false;


  @override
  Widget build(BuildContext context) {
    ///
    ScreenScaler scale = ScreenScaler()..init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Sathaye"),
        backgroundColor: Colors.deepPurpleAccent,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: scale.getPaddingAll(15),
            child: Container(
              child: Image.asset("assets/logo.jpg")
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
                      labelText: "Phone No.",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                      )
                    ),
                    controller: _phoneController,
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    /// if the phone number is not equal to 10 numeric characters return error
                    validator: (val) => RegExp(r'[0-9]{10}').hasMatch(val) ? null : "Please enter a valid phone number"
                  ),
                ),
                Padding(
                  padding: scale.getPadding(0.5, 3),
                  child: TextFormField(
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        padding: scale.getPadding(0, 3),
                        icon: Icon(Icons.remove_red_eye, color: passwordVisible? Colors.deepPurpleAccent : Colors.grey,),
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
                    maxLength: 10,
                    obscureText: !passwordVisible,
                    /// If the password is empty return or less than 8 characters an error
                    validator: (val) => val.isNotEmpty && val.length >= 8 ? null : "Please enter a valid password"
                  ),
                )
              ],
            ),
          ),
          RaisedButton(
            child: Text("Login", style: TextStyle(color: Colors.white, fontSize: scale.getTextSize(11))),
            color: Colors.deepPurpleAccent,
            padding: scale.getPadding(0.5, 3),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onPressed: (){
              if(!_formKey.currentState.validate()) return;
              
              print("Login button pressed");
            },
          ),
          Spacer(),
          Container(
            color: Colors.deepPurpleAccent,
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