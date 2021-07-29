import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/functions.dart';
import 'package:todo_app/provider/google_sign_in.dart';

class TaskPage extends StatefulWidget {
  final GoogleSignInProvider provider;

  const TaskPage({Key? key, required this.provider}) : super(key: key);
  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final _controller = TextEditingController();
  DateTime date = DateTime.now();
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    DocumentReference<Map<String, dynamic>> taskList =
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
          showModalBottomSheet(
            backgroundColor: Colors.white,
            context: context,
            builder: (context) {
              return AddTask(controller: _controller, user: user);
            },
          );
        },
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder<QuerySnapshot>(
          stream: taskList.collection("tasks").snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> querySnapshot) {
            if (querySnapshot.hasError) {
              return Text("Some Error");
            } else if (querySnapshot.connectionState ==
                ConnectionState.waiting) {
              return Center(child: Text("Please wait..."));
            } else if (querySnapshot.data!.docs.length == 0) {
              return Center(
                  child: Container(
                decoration: BoxDecoration(
                    color: Colors.pinkAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10.0)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "No tasks available\n   Press + to add",
                    style: GoogleFonts.dmSans(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ));
            }
            widget.provider.tasks = querySnapshot.data!.docs.length;
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
                      onDismissed: (direction) => taskList
                          .collection("tasks")
                          .doc(snapshot.id)
                          .delete(),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          height: 65,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.pinkAccent.withOpacity(0.1),
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.white,
                            //     offset: Offset(-5, -5),
                            //     blurRadius: 8,
                            //     spreadRadius: 1,
                            //   ),
                            //   BoxShadow(
                            //       color: Color(0xff9E9E9E),
                            //       offset: Offset(5, 5),
                            //       blurRadius: 8.0,
                            //       spreadRadius: 1)
                            // ],
                          ),
                          child: ListTile(
                            leading: Icon(
                              Icons.task_alt,
                              color: Colors.black,
                            ),
                            title: Text(
                              snapshot["title"],
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 18.0,
                              ),
                            ),
                            subtitle: Text(
                              "To be done on : " +
                                  Functions.formatMyDate(snapshot["date"]),
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                              ),
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

class AddTask extends StatefulWidget {
  AddTask({
    Key? key,
    required TextEditingController controller,
    required this.user,
  })  : _controller = controller,
        super(key: key);

  final TextEditingController _controller;
  final User? user;

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  var dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        child: Icon(Icons.arrow_forward_ios),
        onPressed: () {
          final taskName = widget._controller.text;
          final date = dateTime.toString();

          if (taskName.length > 0) {
            FirebaseFirestore.instance
                .collection("Users")
                .doc(widget.user!.uid)
                .collection("tasks")
                .add({
              "title": taskName,
              "date": date,
            }).whenComplete(() => {
                      widget._controller.clear(),
                      Navigator.of(context).pop(),
                    });
          } else {
            print("Every field is Required");
            Fluttertoast.showToast(
              msg: "Every Field is Required",
            );
          }
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: Text(
                  "Add Task",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400, fontSize: 28.0),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                "What to be Done?",
                style: GoogleFonts.dmSans(fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 5.0,
              ),
              Container(
                height: 50.0,
                width: 300,
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      style: GoogleFonts.dmSans(),
                      controller: widget._controller,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Enter task title',
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                "To be Done on",
                style: GoogleFonts.dmSans(fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 5.0,
              ),
              Container(
                  height: 50.0,
                  width: 300,
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Functions.formatMyDate(dateTime.toString()),
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400, color: Colors.black),
                        ),
                        IconButton(
                          onPressed: () {
                            showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1970),
                                    lastDate: DateTime(2100),
                                    initialDate: dateTime)
                                .then((date) {
                              setState(() {
                                dateTime = date!;
                              });
                            });
                          },
                          icon: Icon(
                            Icons.calendar_today,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  )),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
