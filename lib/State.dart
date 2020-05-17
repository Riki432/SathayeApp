import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppState{
  /// First name of the student.
  static String firstName = "";
  
  /// Last name of the student.
  static String lastName = "";

  /// Combination of first and last name. Mostly used for Admins.
  static String name = "";

  /// Used to make sure that current user is an admin or not, by default it's false.
  static bool isAdmin = false;

  /// PRN number of the student.
  static String prn = "";

  ///Phone number of the student.
  static String phone = "";

  /// Department of the student.
  static String department = "";

  /// Year the student is in.
  static String year = "";
  
  /// College UID of the student.
  static String uuid = "";

  ///Firebase ID of the user's document. Mostly used for Admins.
  static String uid = "";
  

  /// Takes a [DocumentSnapshot] of Students Collection and loads the app state. 
  static void loadState(DocumentSnapshot document){
    AppState.firstName  = document.data["FirstName"];
    AppState.lastName   = document.data["LastName"];
    AppState.phone      = document.data["Phone"];
    AppState.department = document.data["Department"];
    AppState.year       = document.data["Year"];
    AppState.prn        = document.data["PRN"];
    AppState.uuid       = document.data["UUID"];
    AppState.isAdmin    = false;
    AppState.uid        = document.documentID;
  }


  /// Takes a [FirebaseUser] and loads the appstate. Only for Admins.
  static void loadAdminState(FirebaseUser user){
      AppState.name      = user.displayName;
      AppState.firstName = user.displayName.split(" ")[0];
      AppState.lastName  = user.displayName.split(" ")[1];
      AppState.isAdmin   = true;
      AppState.uid       = user.uid;
  }
}