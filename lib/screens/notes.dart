import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/screens/addNotes.dart';

class Notes extends StatelessWidget {
  CollectionReference notesList =
      FirebaseFirestore.instance.collection('notes');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        child: FloatingActionButton(
            backgroundColor: Colors.pinkAccent,
            child: Icon(
              Icons.add,
              color: Colors.black,
              size: 35.0,
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddNotes()));
            }),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: StreamBuilder(
              stream: notesList.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
                if (snapshots.hasData) {
                  return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, crossAxisSpacing: 5.0),
                      itemCount: snapshots.data!.docs.length,
                      itemBuilder: (context, index) {
                        return NotesWidget(
                            snapshot: snapshots.data!.docs[index]);
                      });
                }
                return CircularProgressIndicator();
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
                onTap: () => FirebaseFirestore.instance
                    .collection("notes")
                    .doc(snapshot.id)
                    .delete().whenComplete(() => Navigator.pop(context)),
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: kBoxShaow),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.get("title"),
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0,
                  ),
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
