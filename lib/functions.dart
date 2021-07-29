import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/provider/google_sign_in.dart';

import 'constants.dart';

class Functions {
  static Future<int> getNotes(context) async {
    var notes = await FirebaseFirestore.instance
        .collection("Users")
        .doc(user!.uid)
        .collection("notes")
        .snapshots()
        .length;
    print(notes.toString());
    Provider.of<GoogleSignInProvider>(context).notes = notes;
    return notes;
  }
}
