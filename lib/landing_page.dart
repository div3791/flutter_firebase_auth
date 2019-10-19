import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/auth_services/auth.dart';
import 'package:flutter_firebase_auth/auth_services/firebase_auth_service.dart';
import 'package:flutter_firebase_auth/auth_services/user.dart';
import 'package:flutter_firebase_auth/home.dart';
import 'package:flutter_firebase_auth/login_widget.dart';

class LandingPage extends StatelessWidget {
  Auth auth = FirebaseAuthService();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: auth.onAuthStateChange,
        builder: (context, snapshot) {
          User user= snapshot.data;
          if(user==null) {
            return LoginWidget();
          }else {
            return HomePage();
          }
        }
    );
  }
}
