import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/constants.dart';

class AddNotes extends StatelessWidget {
  var titleController = TextEditingController();
  var descController = TextEditingController();
  CollectionReference ref = FirebaseFirestore.instance.collection("notes");
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text(
            "Add Notes",
            style: GoogleFonts.dmSans(
                color: Colors.black, fontWeight: FontWeight.w500),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.save_alt,
                color: Colors.black,
              ),
              onPressed: () {
                ref.add({
                  "title": titleController.text,
                  "description": descController.text,
                }).whenComplete(() => Navigator.pop(context));
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
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  alignment: Alignment.center,
                  height: 60.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: kBoxShaow),
                  child: TextField(
                    controller: titleController,
                    style: GoogleFonts.dmSans(),
                    textAlign: TextAlign.center,
                    decoration:
                        InputDecoration.collapsed(hintText: 'Enter note title'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 15.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.65,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: kBoxShaow),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 15.0),
                    child: TextField(
                      controller: descController,
                      expands: true,
                      maxLines: null,
                      
                      style: GoogleFonts.dmSans(),
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
