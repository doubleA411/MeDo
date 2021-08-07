import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn(scopes: ['email']);
  bool _isSigningIn = false;
  GoogleSignInProvider() {
    _isSigningIn = false;
  }

  bool get isSigningIn => _isSigningIn;

  set isSigningIn(bool isSigningIn) {
    _isSigningIn = isSigningIn;
    notifyListeners();
  }

  Future<void> login() async {
    isSigningIn = true;
    try {
      GoogleSignInAccount? user = await googleSignIn
          .signIn()
          .onError((dynamic signinError, StackTrace stackTrace) {
        throw signinError.toString();
      }).catchError((dynamic onSigninError) {
        throw onSigninError.toString();
      });
      if (user == null) {
        isSigningIn = false;
        return;
      } else {
        GoogleSignInAuthentication googleAuth = await user.authentication;
        OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .catchError((dynamic onSigninCredsError) {
          throw onSigninCredsError.toString();
        });
        isSigningIn = false;
      }
    } on PlatformException catch (err) {
      throw err.toString();
    } catch (error) {
      throw error.toString();
    }
  }

  var tasks = 0;
  var notes = 0;
  // Future login() async {
  //   final user = await googleSignIn.signIn();
  //   if (user == null) {
  //     isSigningIn = false;
  //     return;
  //   } else {
  //     try {
  //       final googleAuth = await user.authentication;

  //       final credential = GoogleAuthProvider.credential(
  //         accessToken: googleAuth.accessToken,
  //         idToken: googleAuth.idToken,
  //       );
  //       await FirebaseAuth.instance.signInWithCredential(credential);
  //     } catch (e) {
  //       print(e);
  //     }

  //     isSigningIn = false;
  //   }
  // }
  Future<void> logout(context) async {
    try {
      await googleSignIn
          .disconnect()
          .onError((Object? error, StackTrace stackTrace) async {
        await FirebaseAuth.instance.signOut();
      });
      Navigator.pop(context);
      await FirebaseAuth.instance.signOut();
      // Navigator.popUntil(context, (route) => route.isFirst);
    } on PlatformException catch (err) {
      throw err.toString();
    } catch (error) {
      throw error.toString();
    }
  }

  var userID = "";

  notifyListeners();
}
