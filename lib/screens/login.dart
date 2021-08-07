import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/provider/google_sign_in.dart';

class LoginUI extends StatelessWidget {
  const LoginUI({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff185ADB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome,\nAdd.\nComplete.\nRepeat.",
                style: GoogleFonts.dmSans(
                  fontSize: 30.0,
                  color: Color(0xffEFEFEF),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Image.asset("assets/Saly-42.png"),
              GestureDetector(
                onTap: () {
                  var provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.login();
                },
                child: Center(
                  child: Container(
                    height: 60.0,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Color(0xffEFEFEF),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          "https://www.freepnglogos.com/uploads/google-logo-png/google-logo-png-google-icon-logo-png-transparent-svg-vector-bie-supply-14.png",
                          height: 25.0,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          "Continue with Google",
                          style: GoogleFonts.dmSans(
                            color: Color(0xff0A1931),
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
