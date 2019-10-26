import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_auth/auth_services/auth.dart';
import 'package:flutter_firebase_auth/auth_services/error_message.dart';
import 'package:flutter_firebase_auth/auth_services/firebase_auth_service.dart';
import 'package:flutter_firebase_auth/facebook_login_button.dart';
import 'package:flutter_firebase_auth/google_login_button.dart';
import 'package:flutter_firebase_auth/home.dart';
import 'package:flutter_firebase_auth/phone_number_login_widget.dart';
import 'package:flutter_firebase_auth/sign_up_widget.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _formKey = GlobalKey<FormState>();
  String email;
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
                    'Login',
                    style: Theme.of(context).textTheme.display1,
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
                    height: 24,
                  ),
                  isLoading
                      ? CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          child: RaisedButton(
                            color: Colors.blueGrey,
                            textTheme: ButtonTextTheme.primary,
                            child: Text('Login'),
                            onPressed: _login,
                          ),
                        ),
                  SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      color: Colors.blue,
                      textTheme: ButtonTextTheme.primary,
                      child: Text('Create Account'),
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => SignUpWidget())),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Divider(
                          color: Colors.grey,
                        )),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Or'),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FacebookLoginButton(),
                  GoogleLoginButton(),
                  SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      color: Colors.blue,
                      textTheme: ButtonTextTheme.primary,
                      child: Text('Login with Phone Number'),
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => PhoneNumberLoginWidget())),
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
        error = '';
      });
      try {
        await auth.signInWithEmailAndPassword(email, password);
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
