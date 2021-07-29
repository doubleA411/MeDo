import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/provider/google_sign_in.dart';
import 'package:todo_app/screens/addNotes.dart';

// final user = FirebaseAuth.instance.currentUser;

class Notes extends StatefulWidget {
  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  var user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    DocumentReference<Map<String, dynamic>> notesList =
        FirebaseFirestore.instance.collection('Users').doc(user!.uid);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.pinkAccent,
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 25.0,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddNotes()));
          }),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: StreamBuilder(
              stream: notesList.collection("notes").snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
                if (snapshots.data != null &&
                    snapshots.data!.docs.length != 0) {
                  Provider.of<GoogleSignInProvider>(context).notes =
                      snapshots.data!.docs.length;
                  return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, crossAxisSpacing: 5.0),
                      itemCount: snapshots.data!.docs.length,
                      itemBuilder: (context, index) {
                        return NotesWidget(
                            snapshot: snapshots.data!.docs[index]);
                      });
                }
                return Center(
                    child: Container(
                  decoration: BoxDecoration(
                      color: Colors.pinkAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "No notes available\n   Press + to add",
                      style: GoogleFonts.dmSans(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ));
              }),
        ),
      ),
    );
  }
}

class NotesWidget extends StatelessWidget {
  const NotesWidget({
    Key? key,
    required this.snapshot,
  }) : super(key: key);
  final DocumentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return NoteView(
                snapshot: snapshot,
              );
            });
      },
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              "Delete Note ?",
              style: GoogleFonts.dmSans(color: Colors.red),
            ),
            content: Text(
              snapshot.get("title") + " will be deleted",
              style: GoogleFonts.dmSans(),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  FirebaseFirestore.instance
                      .collection("Users")
                      .doc(user!.uid)
                      .collection("notes")
                      .doc(snapshot.id)
                      .delete();
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Delete",
                    style: GoogleFonts.dmSans(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.dmSans(),
                  ),
                ),
              )
            ],
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.pinkAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.notes,
                      size: 20.0,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Expanded(
                      child: Text(
                        snapshot.get("title"),
                        overflow: TextOverflow.clip,
                        softWrap: true,
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w500,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Expanded(
                  child: Text(
                    snapshot.get("description"),
                    softWrap: true,
                    style: GoogleFonts.dmSans(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NoteView extends StatelessWidget {
  const NoteView({Key? key, required this.snapshot}) : super(key: key);
  final DocumentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                snapshot.get("title"),
                style: GoogleFonts.dmSans(
                  fontSize: 25.0,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                snapshot.get("description"),
                softWrap: true,
                style: GoogleFonts.dmSans(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
