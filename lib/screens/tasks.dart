import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/provider/google_sign_in.dart';

class TaskPage extends StatefulWidget {
  final GoogleSignInProvider provider;

  const TaskPage({Key? key, required this.provider}) : super(key: key);
  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final _controller = TextEditingController();

  void _addTask() {}
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    DocumentReference<Map<String, dynamic>> taskList =
        FirebaseFirestore.instance.collection('Users').doc(user!.uid);

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
                return AddTask(controller: _controller, user: user);
              },
            );
          },
        ),
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
              return Text("Please wait...");
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

class AddTask extends StatelessWidget {
  const AddTask({
    Key? key,
    required TextEditingController controller,
    required this.user,
  })  : _controller = controller,
        super(key: key);

  final TextEditingController _controller;
  final User? user;

  @override
  Widget build(BuildContext context) {
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
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
          child: Container(
            height: 50.0,
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
                  hintText: 'Enter task title',
                  
                ),
              ),
            ),
          ),
        ),
        FlatButton(
          onPressed: () {
            final taskName = _controller.text;

            FirebaseFirestore.instance
                .collection("Users")
                .doc(user!.uid)
                .collection("tasks")
                .add({"title": taskName}).whenComplete(() => {
                      _controller.clear(),
                      Navigator.of(context).pop(),
                    });
          },
          child: Text(
            "Add",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          color: Colors.greenAccent,
        ),
      ],
    );
  }
}
