import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/provider/google_sign_in.dart';

class AddNotes extends StatelessWidget {
  var titleController = TextEditingController();
  var descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    CollectionReference<Map<String, dynamic>> ref = FirebaseFirestore.instance
        .collection("Users")
        .doc(user!.uid)
        .collection("notes");
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color(0xff0A1931),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text(
            "Add Notes",
            style: GoogleFonts.dmSans(
                color: Color(0xff0A1931), fontWeight: FontWeight.w500),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.done,
                color: Color(0xff0A1931),
              ),
              onPressed: () {
                if (titleController.text.length > 0 &&
                    descController.text.length > 0) {
                  ref.add({
                    "title": titleController.text,
                    "description": descController.text,
                    "date": DateTime.now().toString(),
                  }).whenComplete(() => Navigator.pop(context));
                } else {
                  Fluttertoast.showToast(msg: "Every Field is Required");
                }
              },
            ),
            SizedBox(
              width: 10.0,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  alignment: Alignment.center,
                  height: 60.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: titleController,
                      style: GoogleFonts.dmSans(
                          fontSize: 30.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                      decoration: InputDecoration.collapsed(
                          hintText: 'Enter note title'),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.65,
                  // decoration: BoxDecoration(
                  //   color: Color(0xff185ADB).withOpacity(0.2),
                  //   borderRadius: BorderRadius.circular(15.0),
                  //   // boxShadow: kBoxShaow
                  // ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: descController,
                      expands: true,
                      maxLines: null,
                      style: GoogleFonts.dmSans(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration:
                          InputDecoration.collapsed(hintText: 'Description'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
