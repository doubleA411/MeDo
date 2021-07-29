import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/functions.dart';
import 'package:todo_app/provider/google_sign_in.dart';
import 'package:todo_app/screens/login.dart';
import 'package:todo_app/screens/notes.dart';
import 'package:todo_app/screens/tasks.dart';
import 'package:todo_app/screens/user_details.dart';
import 'package:todo_app/upload.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      Provider<GoogleSignInProvider>(
          create: (context) => GoogleSignInProvider()),
    ],
    child: App(),
  ));
}

class App extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => GoogleSignInProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ToDo App',
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            final provider = Provider.of<GoogleSignInProvider>(context);

            if (provider.isSigningIn) {
              return SigningIn();
            } else if (!snapshot.hasData) {
              return LoginUI();
            } else if (snapshot.hasData) {
              return Tabs();
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.data.toString()),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

class Tabs extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Functions.getNotes(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserDetails()));
              },
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(user!.photoURL.toString()),
                    )),
              ),
            ),
          ),
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
          bottom: TabBar(
            indicatorColor: kPrimarrColor,
            labelPadding: const EdgeInsets.all(10),
            indicatorWeight: 2.0,
            tabs: [
              Text(
                "Tasks",
                style: GoogleFonts.dmSans(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 15.0),
              ),
              Text(
                "Notes",
                style: GoogleFonts.dmSans(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 15.0),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TaskPage(
              provider:
                  Provider.of<GoogleSignInProvider>(context, listen: false),
            ),
            Notes(),
          ],
        ),
      ),
    );
  }
}

class SigningIn extends StatelessWidget {
  const SigningIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 60.0,
              width: 60.0,
              child: CircularProgressIndicator(
                strokeWidth: 8.0,
                color: Colors.pinkAccent,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text("Signing In")
          ],
        ),
      ),
    );
  }
}
