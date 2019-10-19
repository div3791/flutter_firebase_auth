import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_auth/auth_services/auth.dart';
import 'package:flutter_firebase_auth/auth_services/error_message.dart';
import 'package:flutter_firebase_auth/auth_services/firebase_auth_service.dart';
import 'package:flutter_firebase_auth/auth_services/user.dart';
import 'package:flutter_firebase_auth/facebook_login_button.dart';
import 'package:flutter_firebase_auth/google_login_button.dart';
import 'package:flutter_firebase_auth/home.dart';

class SignUpWidget extends StatefulWidget {
  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String name;
  String password;
  bool isLoading = false;
  String error = '';

  Auth auth = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(24),
        shrinkWrap: true,
        children: <Widget>[
          Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 24,
                  ),
                  Text(
                    'Sign Up',
                    style: Theme.of(context).textTheme.display1,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Divyesh Shani',
                      labelText: 'Name',
                      contentPadding: EdgeInsets.all(4),
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (val) => name = val,
                    validator: (val) {
                      if (val.length <= 0) {
                        return 'Enter Name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'abc@xyz.com',
                      labelText: 'Email ID',
                      contentPadding: EdgeInsets.all(4),
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (val) => email = val,
                    validator: (val) {
                      if (val.length <= 0) {
                        return 'Enter Email ID';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: '******',
                      labelText: 'Password',
                      contentPadding: EdgeInsets.all(4),
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    onSaved: (val) => password = val,
                    validator: (val) {
                      if (val.length <= 0) {
                        return 'Enter Password';
                      }
                      return null;
                    },
                  ),
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
                            )
                          ],
                        )
                      : Container(),
                  SizedBox(
                    height: 16,
                  ),
                  isLoading
                      ? CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          child: RaisedButton(
                            color: Colors.blue,
                            textTheme: ButtonTextTheme.primary,
                            child: Text('Create Account'),
                            onPressed: _login,
                          ),
                        ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _login() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        isLoading = true;
      });
      try {
        await auth.createUserWithEmailAndPassword(name, email, password);
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => HomePage(),
          ),
        );
      } on PlatformException catch (e) {
        setState(() {
          isLoading = false;
          error = ErrorHandling.getErrorMessage(e);
        });
      }
    }
  }
}
