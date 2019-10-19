import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_auth/auth_services/auth.dart';
import 'package:flutter_firebase_auth/auth_services/error_message.dart';
import 'package:flutter_firebase_auth/auth_services/firebase_auth_service.dart';
import 'package:flutter_firebase_auth/home.dart';

class GoogleLoginButton extends StatefulWidget {
  @override
  _GoogleLoginButtonState createState() => _GoogleLoginButtonState();
}

class _GoogleLoginButtonState extends State<GoogleLoginButton> {
  Auth auth = FirebaseAuthService();

  String error = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator())
        : SizedBox(
            width: double.infinity,
            child: RaisedButton(
              color: Colors.redAccent.shade200.withOpacity(0.8),
              textTheme: ButtonTextTheme.primary,
              child: Text('Login with Google'),
              onPressed: () {},
            ),
          );
  }
}
