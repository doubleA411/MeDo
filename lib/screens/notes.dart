import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/functions.dart';
import 'package:todo_app/provider/google_sign_in.dart';
import 'package:todo_app/screens/addNotes.dart';
import 'package:todo_app/screens/editNotes.dart';

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
          backgroundColor: Color(0xff185ADB),
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
                      color: Color(0xff185ADB).withOpacity(0.2),
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

class NotesWidget extends StatefulWidget {
  const NotesWidget({
    Key? key,
    required this.snapshot,
  }) : super(key: key);
  final DocumentSnapshot snapshot;

  @override
  State<NotesWidget> createState() => _NotesWidgetState();
}

enum delete { yes, no }

class _NotesWidgetState extends State<NotesWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double begin = 0.0;
  double end = 0.01;
  bool isPressed = false;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.stop();
        setState(() {
          begin = 0.0;
          end = 0.0;
        });
        if (isPressed == false) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditNotes(
                        snapshot: widget.snapshot,
                      )));
        } else if (isPressed == true) {
          setState(() {
            isPressed = false;
          });
        }
        // showDialog(
        //     context: context,
        //     builder: (context) {
        //       return EditNotes(
        //         snapshot: widget.snapshot,
        //       );
        //     });
      },
      onLongPress: () {
        setState(() {
          isPressed = !isPressed;
          begin = 0.0;
          end = 0.01;
        });
        _controller.forward();
        _controller.repeat(reverse: true);

        // showDialog(
        //   context: context,
        //   builder: (context) => AlertDialog(
        //     title: Text(
        //       "Delete Note ?",
        //       style: GoogleFonts.poppins(
        //           color: Color(0xff0A1931), fontWeight: FontWeight.w600),
        //     ),
        //     content: Text(
        //       snapshot.get("title") + " will be deleted",
        //       style: GoogleFonts.poppins(),
        //     ),
        //     actions: [
        //
        //         child: Padding(
        //           padding: const EdgeInsets.all(10.0),
        //           child: Text(
        //             "Delete",
        //             style: GoogleFonts.poppins(
        //                 color: Colors.red, fontWeight: FontWeight.bold),
        //           ),
        //         ),
        //       ),
        //       GestureDetector(
        //         onTap: () => Navigator.pop(context),
        //         child: Padding(
        //           padding: const EdgeInsets.all(10.0),
        //           child: Text(
        //             "Cancel",
        //             style: GoogleFonts.poppins(),
        //           ),
        //         ),
        //       )
        //     ],
        //   ),
        // );
      },
      child: Stack(
        children: [
          RotationTransition(
            turns: Tween(begin: begin, end: end).animate(_controller),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xffBEDCFA),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 15.0),
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
                              widget.snapshot.get("title"),
                              overflow: TextOverflow.clip,
                              softWrap: true,
                              style: GoogleFonts.dmSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                                color: Color(0xff0A1931),
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
                          widget.snapshot.get("description"),
                          softWrap: true,
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w600,
                            color: Color(0xff0A1931),
                          ),
                        ),
                      ),
                      Text(
                        Functions.formatMyDate(
                          widget.snapshot.get("date"),
                        ),
                        style: GoogleFonts.dmSans(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: isPressed,
            child: GestureDetector(
              onTap: () {
                FirebaseFirestore.instance
                    .collection("Users")
                    .doc(user!.uid)
                    .collection("notes")
                    .doc(widget.snapshot.id)
                    .delete();
                setState(() {
                  isPressed = false;
                });
              },
              child: Container(
                height: 25.0,
                width: 25.0,
                decoration: BoxDecoration(
                  color: Color(0xffFF2626),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.remove, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
