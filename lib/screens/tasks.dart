import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/functions.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/provider/google_sign_in.dart';
import 'package:toggle_switch/toggle_switch.dart';

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
        backgroundColor: Color(0xff185ADB),
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 25.0,
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddTask(
                        controller: _controller,
                        user: user,
                      )));
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
                    color: Color(0xff185ADB).withOpacity(0.2),
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
                return TaskWidget(
                  taskList: taskList,
                  snapshot: snapshot,
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

class TaskWidget extends StatelessWidget {
  const TaskWidget({
    Key? key,
    required this.taskList,
    required this.snapshot,
  }) : super(key: key);

  final DocumentReference<Map<String, dynamic>> taskList;
  final DocumentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
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
                Icons.delete_outline_rounded,
                size: 30.0,
                color: Color(0xffFF2626),
              ),
            ),
          ),
          onDismissed: (direction) =>
              taskList.collection("tasks").doc(snapshot.id).delete(),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
                height: 65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Color(0xffBEDCFA),
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
                child: snapshot['isPressed'] == 'task'
                    ? ListTile(
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
                          "On : " +
                              (Functions.formatMyDate(snapshot["date"]) ==
                                      Functions.formatMyDate(
                                          DateTime.now().toString())
                                  ? "Today"
                                  : Functions.formatMyDate(snapshot["date"])),
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : ListTile(
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
                          "On : " +
                              (Functions.formatMyDate(snapshot["date"]) ==
                                      Functions.formatMyDate(
                                          DateTime.now().toString())
                                  ? "Today"
                                  : Functions.formatMyDate(snapshot["date"])),
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.watch,
                              size: 20.0,
                            ),
                            Text(
                              snapshot['time'],
                              style: GoogleFonts.dmSans(fontSize: 15.0),
                            ),
                          ],
                        ),
                      )),
          ),
        ));
  }
}

enum Option {
  task,
  reminder,
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
  Option isPressed = Option.task;
  var time = "";
  var selectedIndex = 0;
  Future<void> _showTime() async {
    final TimeOfDay? result =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (result != null) {
      setState(() {
        time = result.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios,
                color: Color(0xff185ADB),
              )),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xff185ADB),
          child: Icon(Icons.arrow_forward_ios),
          onPressed: () {
            final taskName = widget._controller.text;
            final date = dateTime.toString();

            if (taskName.length > 0 && isPressed == Option.task) {
              FirebaseFirestore.instance
                  .collection("Users")
                  .doc(widget.user!.uid)
                  .collection("tasks")
                  .add({
                "title": taskName,
                "date": date,
                'isPressed': isPressed.toString().replaceAll("Option.", ""),
              }).whenComplete(() => {
                        widget._controller.clear(),
                        Navigator.of(context).pop(),
                      });
            } else if (taskName.length > 0 && isPressed == Option.reminder) {
              FirebaseFirestore.instance
                  .collection("Users")
                  .doc(widget.user!.uid)
                  .collection("tasks")
                  .add({
                "title": taskName,
                "date": date,
                'time': time,
                'isPressed': isPressed.toString().replaceAll("Option.", ""),
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
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Add ",
                              style: GoogleFonts.poppins(
                                  color: Color(0xff0A1931),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28.0),
                            ),
                            isPressed == Option.task
                                ? Text(
                                    "Task",
                                    style: GoogleFonts.poppins(
                                        color: Color(0xff0A1931),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28.0),
                                  )
                                : Text(
                                    "Reminder",
                                    style: GoogleFonts.poppins(
                                        color: Color(0xff0A1931),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28.0),
                                  ),
                          ],
                        ),
                        //
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => setState(() {
                                isPressed = Option.task;
                              }),
                              child: Container(
                                alignment: Alignment.center,
                                width: 80.0,
                                decoration: BoxDecoration(
                                  boxShadow:
                                      isPressed == Option.task ? [] : kBoxShaow,
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: isPressed == Option.task
                                      ? Color(0xff185ADB)
                                      : Color(0xfff5f7fb),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Task",
                                      style: GoogleFonts.dmSans(
                                        color: isPressed == Option.task
                                            ? Colors.white
                                            : Colors.black,
                                      )),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            GestureDetector(
                              onTap: () => setState(() {
                                isPressed = Option.reminder;
                              }),
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                alignment: Alignment.center,
                                width: 80.0,
                                decoration: BoxDecoration(
                                  boxShadow: isPressed == Option.reminder
                                      ? []
                                      : kBoxShaow,
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: isPressed == Option.reminder
                                      ? Color(0xff185ADB)
                                      : Color(0xfff5f7fb),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Reminder",
                                      style: GoogleFonts.dmSans(
                                        color: isPressed == Option.reminder
                                            ? Colors.white
                                            : Colors.black,
                                      )),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 30.0,
                    color: Color(0xff0A1931),
                  ),
                  Text(
                    "What to be Done?",
                    style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    height: 60.0,
                    width: 350,
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(10.0),
                    //   color: Color(0xff185ADB).withOpacity(0.2),
                    //   // boxShadow: [
                    //   //   BoxShadow(
                    //   //     color: Colors.white,
                    //   //     offset: Offset(-5, -5),
                    //   //     blurRadius: 8,
                    //   //     spreadRadius: 1,
                    //   //   ),
                    //   //   BoxShadow(
                    //   //       color: Color(0xff9E9E9E),
                    //   //       offset: Offset(5, 5),
                    //   //       blurRadius: 8.0,
                    //   //       spreadRadius: 1)
                    //   // ],
                    // ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          style: GoogleFonts.dmSans(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                          controller: widget._controller,
                          textAlign: TextAlign.left,
                          decoration:
                              InputDecoration.collapsed(hintText: 'Title'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    "To be Done on",
                    style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                      height: 60.0,
                      width: 350,
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(10.0),
                      //   color: Color(0xff185ADB).withOpacity(0.2),

                      //   // boxShadow: [
                      //   //   BoxShadow(
                      //   //     color: Colors.white,
                      //   //     offset: Offset(-5, -5),
                      //   //     blurRadius: 8,
                      //   //     spreadRadius: 1,
                      //   //   ),
                      //   //   BoxShadow(
                      //   //       color: Color(0xff9E9E9E),
                      //   //       offset: Offset(5, 5),
                      //   //       blurRadius: 8.0,
                      //   //       spreadRadius: 1)
                      //   // ],
                      // ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Functions.formatMyDate(dateTime.toString()),
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff0A1931),
                                  fontSize: 20.0),
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
                                color: Color(0xff0A1931),
                              ),
                            ),
                          ],
                        ),
                      )),
                  SizedBox(
                    height: 15.0,
                  ),
                  Visibility(
                    visible: isPressed == Option.reminder ? true : false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "To be Done at",
                          style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Container(
                            height: 60.0,
                            width: 350,
                            // decoration: BoxDecoration(
                            //   borderRadius: BorderRadius.circular(10.0),
                            //   color: Color(0xff185ADB).withOpacity(0.2),

                            //   // boxShadow: [
                            //   //   BoxShadow(
                            //   //     color: Colors.white,
                            //   //     offset: Offset(-5, -5),
                            //   //     blurRadius: 8,
                            //   //     spreadRadius: 1,
                            //   //   ),
                            //   //   BoxShadow(
                            //   //       color: Color(0xff9E9E9E),
                            //   //       offset: Offset(5, 5),
                            //   //       blurRadius: 8.0,
                            //   //       spreadRadius: 1)
                            //   // ],
                            // ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    time.isEmpty ? "00:00" : time,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff0A1931),
                                        fontSize: 20.0),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _showTime();
                                    },
                                    icon: Icon(
                                      Icons.alarm,
                                      color: Color(0xff0A1931),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
