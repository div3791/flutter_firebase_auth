import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_auth/auth_services/auth.dart';
import 'package:flutter_firebase_auth/auth_services/error_message.dart';
import 'package:flutter_firebase_auth/auth_services/firebase_auth_service.dart';
import 'package:flutter_firebase_auth/home.dart';

class FacebookLoginButton extends StatefulWidget {
  @override
  _FacebookLoginButtonState createState() => _FacebookLoginButtonState();
}

class _FacebookLoginButtonState extends State<FacebookLoginButton> {
  Auth auth = FirebaseAuthService();

  String error = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          (error.length >= 1 && !isLoading)
              ? Column(
                  children: <Widget>[
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      error,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                )
              : Container(),
          isLoading
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator())
              : SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.indigo,
                    textTheme: ButtonTextTheme.primary,
                    child: Text('Login with Facebook'),
                    onPressed: () async {
                      try {
                        setState(() {
                          isLoading = true;
                        });
                        await auth.signInWithFacebook();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => HomePage(),
                          ),
                        );
                        setState(() {
                          isLoading = false;
                        });
                      } on PlatformException catch (e) {
                        setState(() {
                          isLoading = false;
                        });
                        setState(() {
                          print(e.code);
                          error = ErrorHandling.getErrorMessage(e);
                        });
                      }
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
