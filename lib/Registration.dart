import 'package:Sathaye/Departments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  /// Manages the registration form state. Useful for validation.
  final _formKey = GlobalKey<FormState>();

  /// Manages the PRN number field.
  final prnController = TextEditingController();

  /// Manages the first name field.
  final firstNameController = TextEditingController();

  /// Manages the last name field.
  final lastNameController = TextEditingController();

  /// Manages the department field.
  final departmentController = TextEditingController();

  /// Manages the year field.
  final yearController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final scale = ScreenScaler()..init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Form(
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
                    print(value);
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
                    print(value);
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
                    color: Colors.deepPurpleAccent,
                    padding: scale.getPadding(0.5, 3),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    onPressed: () { 

                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
