import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskPage extends StatelessWidget {
  CollectionReference taskList = FirebaseFirestore.instance.collection('tasks');
  final _controller = TextEditingController();

  void _addTask() {
    final taskName = _controller.text;

    FirebaseFirestore.instance.collection("tasks").add({"title": taskName});

    _controller.clear();
  }

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
            showModalBottomSheet(
              backgroundColor: Colors.white,
              context: context,
              builder: (context) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Add Task",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600, fontSize: 20.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                      child: Container(
                        height: 60.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              offset: Offset(-5, -5),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                            BoxShadow(
                                color: Color(0xff9E9E9E),
                                offset: Offset(5, 5),
                                blurRadius: 8.0,
                                spreadRadius: 1)
                          ],
                        ),
                        child: Center(
                          child: TextField(
                            style: GoogleFonts.dmSans(),
                            controller: _controller,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration.collapsed(
                                hintText: 'Enter task title'),
                          ),
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        _addTask();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Add",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                      color: Colors.greenAccent,
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder<QuerySnapshot>(
          stream: taskList.snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> querySnapshot) {
            if (querySnapshot.hasError) {
              return Text("Some Error");
            } else if (querySnapshot.connectionState ==
                ConnectionState.waiting) {
              return Text("Please wait...");
            }
            return new ListView(
              scrollDirection: Axis.vertical,
              children:
                  querySnapshot.data!.docs.map((DocumentSnapshot snapshot) {
                return GestureDetector(
                    onTap: () {
                      print(snapshot.id);
                    },
                    child: Dismissible(
                      key: Key(snapshot.id),
                      background: Container(
                        alignment: Alignment.centerLeft,
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Icon(
                            Icons.delete,
                            size: 30.0,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      onDismissed: (direction) => FirebaseFirestore.instance
                          .collection("tasks")
                          .doc(snapshot.id)
                          .delete(),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          height: 65,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white,
                                offset: Offset(-5, -5),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                              BoxShadow(
                                  color: Color(0xff9E9E9E),
                                  offset: Offset(5, 5),
                                  blurRadius: 8.0,
                                  spreadRadius: 1)
                            ],
                          ),
                          child: ListTile(
                            leading: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Image.asset(
                                "assets/target.png",
                                height: 30.0,
                              ),
                            ),
                            title: Text(
                              snapshot["title"],
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ));
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
