import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/auth_services/auth.dart';
import 'package:flutter_firebase_auth/auth_services/firebase_auth_service.dart';
import 'package:flutter_firebase_auth/home.dart';
import 'package:flutter_firebase_auth/landing_page.dart';
import 'package:flutter_firebase_auth/login_widget.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: LandingPage(),
    );
  }
}
