import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/provider/google_sign_in.dart';
import 'package:todo_app/screens/notes.dart';
import 'package:todo_app/screens/tasks.dart';
import 'package:todo_app/screens/user_details.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  choice isPressed = choice.notes;
  var user = FirebaseAuth.instance.currentUser;
  int initialValue = 0;
  var tasks = 0;
  var notes = 0;

  @override
  void initState() {
    super.initState();
    tabController =
        TabController(length: 2, vsync: this, initialIndex: initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(
            height: 40.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserDetails())),
                  child: Container(
                    height: 50.0,
                    width: 50.0,
                    decoration: BoxDecoration(
                        color: Color(0xfff5f7fb),
                        image: DecorationImage(
                            image: NetworkImage(user!.photoURL.toString())),
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Text(
                  user!.displayName.toString(),
                  style: GoogleFonts.dmSans(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 30.0),
          Container(
              height: 280.0,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() {
                      isPressed = choice.notes;
                    }),
                    child: Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 10.0),
                        height: 240.0,
                        width: 175.0,
                        decoration: BoxDecoration(
                            color: isPressed == choice.notes
                                ? Color(0xff185ADB)
                                : Color(0xfff5f7fb),
                            borderRadius: BorderRadius.circular(15.0)),
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("Users")
                              .doc(user!.uid)
                              .collection('notes')
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot?> snapshot) {
                            snapshot.data!.docs.forEach((element) {
                              notes = notes + 1;
                            });

                            Provider.of<GoogleSignInProvider>(context,
                                    listen: false)
                                .notes = notes;
                            notes = 0;

                            return Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Notes",
                                    style: GoogleFonts.dmSans(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25.0,
                                      color: isPressed == choice.notes
                                          ? Colors.white
                                          : Color(0xffafb4c6),
                                    ),
                                  ),
                                  Text(
                                    Provider.of<GoogleSignInProvider>(context)
                                        .notes
                                        .toString(),
                                    style: GoogleFonts.dmSans(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30.0,
                                      color: isPressed == choice.notes
                                          ? Colors.white
                                          : Color(0xffafb4c6),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )),
                  ),
                  GestureDetector(
                    onTap: () => setState(() {
                      isPressed = choice.tasks;
                    }),
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 10.0),
                      height: 240.0,
                      width: 175.0,
                      decoration: BoxDecoration(
                          color: isPressed == choice.tasks
                              ? Color(0xff185ADB)
                              : Color(0xfff5f7fb),
                          borderRadius: BorderRadius.circular(15.0)),
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("Users")
                              .doc(user!.uid)
                              .collection('tasks')
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot?> snapshot) {
                            snapshot.data!.docs.forEach((element) {
                              tasks = tasks + 1;
                            });

                            Provider.of<GoogleSignInProvider>(context,
                                    listen: false)
                                .tasks = tasks;
                            tasks = 0;

                            return Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Tasks",
                                    style: GoogleFonts.dmSans(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25.0,
                                      color: isPressed == choice.tasks
                                          ? Colors.white
                                          : Color(0xffafb4c6),
                                    ),
                                  ),
                                  Text(
                                    Provider.of<GoogleSignInProvider>(context)
                                        .tasks
                                        .toString(),
                                    style: GoogleFonts.dmSans(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30.0,
                                      color: isPressed == choice.tasks
                                          ? Colors.white
                                          : Color(0xffafb4c6),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              )),
          TabBar(
            labelColor: Color(0xff0A1931),
            unselectedLabelColor: Color(0xffafb4c6),
            indicatorColor: Color(0xff417bfb),
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 4.0,
            isScrollable: true,
            controller: tabController,
            tabs: [
              Text(
                "Notes",
                style: GoogleFonts.dmSans(
                    fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              Text(
                "Tasks",
                style: GoogleFonts.dmSans(
                    fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Container(
            height: 325,
            child: TabBarView(controller: tabController, children: [
              Notes(),
              TaskPage(provider: Provider.of<GoogleSignInProvider>(context)),
            ]),
          ),
        ],
      ),
    );
  }
}

enum choice { notes, tasks }
