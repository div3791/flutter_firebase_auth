import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_auth/auth_services/auth.dart';
import 'package:flutter_firebase_auth/auth_services/firebase_auth_service.dart';
import 'package:flutter_firebase_auth/auth_services/user.dart';
import 'package:flutter_firebase_auth/login_widget.dart';

class HomePage extends StatelessWidget {
  Auth auth = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await auth.signOut();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => LoginWidget()));
            },
          )
        ],
      ),
      body: StreamBuilder<User>(
          stream: auth.onAuthStateChange,
          builder: (context, snapshot) {
            User user = snapshot.data;
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Name : ${user?.name ?? ''}'),
                  Text('Email ID : ${user?.emailId ?? ''}'),
                ],
              ),
            );
          }),
    );
  }
}
