import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
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
    GoogleSignInProvider provider = Provider.of<GoogleSignInProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color(0xff185ADB),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50.0,
              backgroundColor: Color(0xfff5f7fb),
              child: Image.network(user!.photoURL.toString()),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              "Username",
              style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            Text(
              user!.displayName.toString(),
              style: GoogleFonts.dmSans(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: Color(0xff0A1931),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              "Email Address",
              style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            Text(
              user!.email.toString(),
              style: GoogleFonts.dmSans(
                fontSize: 25.0,
                fontWeight: FontWeight.w600,
                color: Color(0xff0A1931),
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            InkWell(
              onTap: () async {
                await provider.logout(context);
              },
              child: Container(
                alignment: Alignment.centerRight,
                child: Text(
                  "Logout",
                  style: GoogleFonts.dmSans(
                    color: Colors.red,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Spacer(),
            Center(
              child: Column(
                children: [
                  Text(
                    "from",
                    style: GoogleFonts.dmSans(),
                  ),
                  Text(
                    "MINIMAL MIND",
                    style: GoogleFonts.dmSans(
                        fontSize: 18.0,
                        color: Color(0xff185ADB).withOpacity(0.8)),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
