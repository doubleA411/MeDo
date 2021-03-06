import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const kBoxShaow = [
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
];

const kPrimarrColor = Colors.pinkAccent;

final user = FirebaseAuth.instance.currentUser;
