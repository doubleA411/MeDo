import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/functions.dart';

import 'package:todo_app/provider/google_sign_in.dart';

import '../constants.dart';

class UserDetails extends StatefulWidget {
  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final user = FirebaseAuth.instance.currentUser;
 

  @override
  Widget build(BuildContext context) {
    GoogleSignInProvider provider =
        Provider.of<GoogleSignInProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.pinkAccent,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: Text(
          "User Details",
          style: GoogleFonts.dmSans(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Container(
              alignment: Alignment.center,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.pinkAccent.withOpacity(0.2),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(user!.photoURL.toString()))),
                  ),
                ),
                title: Text(
                  user!.displayName.toString(),
                  style: GoogleFonts.dmSans(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                  ),
                ),
                subtitle: Text(
                  user!.email.toString(),
                  style:
                      GoogleFonts.dmSans(color: Colors.black, fontSize: 12.0),
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Container(
              alignment: Alignment.center,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.pinkAccent.withOpacity(0.2),
              ),
              child: ListTile(
                leading: Icon(
                  Icons.task_alt_rounded,
                  color: Colors.black,
                ),
                title: Text(
                  "Tasks",
                  style: GoogleFonts.dmSans(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0),
                ),
                trailing: Text(
                  provider.tasks.toString(),
                  style: GoogleFonts.dmSans(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0),
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Container(
              alignment: Alignment.center,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.pinkAccent.withOpacity(0.2),
              ),
              child: ListTile(
                leading: Icon(
                  Icons.notes,
                  color: Colors.black,
                ),
                title: Text(
                  "Notes",
                  style: GoogleFonts.dmSans(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0),
                ),
                trailing: Text(
                  provider.notes.toString(),
                  style: GoogleFonts.dmSans(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              await provider.logout(context);
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Container(
                alignment: Alignment.center,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.red.withOpacity(0.1),
                ),
                child: Text(
                  "Logout",
                  style: GoogleFonts.dmSans(color: Colors.red, fontSize: 18.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
