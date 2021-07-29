import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/constants.dart';

class Upload extends StatelessWidget {
  const Upload({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue[900],
        child: Icon(
          Icons.arrow_forward_ios,
        ),
      ),
      appBar: AppBar(
        leading: Icon(Icons.arrow_back_ios),
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        title: Text(
          "Upload Documents",
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Container(
                alignment: Alignment.center,
                height: 60.0,
                decoration: BoxDecoration(
                  boxShadow: kBoxShaow,
                  color: Color(0xff0e1526),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Text(
                  "Upload License",
                  style: GoogleFonts.dmSans(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Container(
                alignment: Alignment.center,
                height: 60.0,
                decoration: BoxDecoration(
                  color: Color(0xff0e1526),
                  boxShadow: kBoxShaow,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Text(
                  "Upload RC",
                  style: GoogleFonts.dmSans(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
