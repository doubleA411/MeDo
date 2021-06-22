import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo App',
      home: TaskPage(),
    );
  }
}

class TaskPage extends StatelessWidget {
  final _controller = TextEditingController();

  void _addTask() {
    final taskName = _controller.text;

    FirebaseFirestore.instance.collection("tasks").add({"title": taskName});

    _controller.clear();
  }

  Widget _buildList(QuerySnapshot? snapshot) {
    return ListView.builder(
      itemCount: snapshot!.docs.length,
      itemBuilder: (context, index) {
        final doc = snapshot.docs[index];
        return Dismissible(
          key: Key(doc.id),
          background: Container(
            color: Colors.red,
          ),
          onDismissed: (direction) => FirebaseFirestore.instance
              .collection("tasks")
              .doc(doc.id)
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
                leading: Icon(
                  Icons.task_alt,
                  color: Colors.black,
                ),
                title: Text(
                  doc["title"],
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Container(
          alignment: Alignment.center,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.pinkAccent,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.black, width: 2.0),
          ),
          child: Text(
            "MeDo!",
            style: GoogleFonts.poppins(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
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
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 40.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            width: 2.0,
                            color: Colors.blueAccent,
                          ),
                        ),
                        child: Center(
                          child: TextField(
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
                    Image.asset(
                      "assets/task.jpg",
                      height: 300,
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Object?>>(
        stream: FirebaseFirestore.instance.collection("tasks").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Image.asset("assets/24.png");

          return _buildList(snapshot.data);
        },
      ),
    );
  }
}
