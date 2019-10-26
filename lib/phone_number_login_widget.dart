import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_auth/auth_services/auth.dart';
import 'package:flutter_firebase_auth/auth_services/error_message.dart';
import 'package:flutter_firebase_auth/auth_services/firebase_auth_service.dart';
import 'package:flutter_firebase_auth/auth_services/user.dart';
import 'package:flutter_firebase_auth/home.dart';

class PhoneNumberLoginWidget extends StatefulWidget {
  @override
  _PhoneNumberLoginWidgetState createState() => _PhoneNumberLoginWidgetState();
}

class _PhoneNumberLoginWidgetState extends State<PhoneNumberLoginWidget> {
  final _phoneNumberFormKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();

  String phoneNumber;
  String smsCode;
  Auth auth = FirebaseAuthService();

  bool isVerificationStarted = false;
  bool isSignInStarted = false;

  String verificationId = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Form(
                key: _phoneNumberFormKey,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: '+00 0000000000',
                    labelText: 'Phone Number',
                    contentPadding: EdgeInsets.all(4),
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  onSaved: (val) => phoneNumber = val,
                  validator: (val) {
                    if (val.length <= 0) {
                      return 'Enter phone number';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 16,
              ),
              verificationId.length <= 0
                  ? isVerificationStarted
                      ? CircularProgressIndicator()
                      : RaisedButton(
                          child: Text('Verify phone number'),
                          onPressed: _verifyPhone,
                        )
                  : Column(
                      children: <Widget>[
                        Form(
                          key: _otpFormKey,
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: '------',
                              labelText: 'Enter OTP',
                              contentPadding: EdgeInsets.all(4),
                            ),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.numberWithOptions(
                                signed: false, decimal: true),
                            onSaved: (val) => smsCode = val,
                            validator: (val) {
                              if (val.length <= 0) {
                                return 'Enter OPT Code';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        isSignInStarted
                            ? CircularProgressIndicator()
                            : RaisedButton(
                                child: Text('Sign In with phone number'),
                                onPressed: _signInWithPhone,
                              )
                      ],
                    ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _verifyPhone() async {
    if (_phoneNumberFormKey.currentState.validate()) {
      _phoneNumberFormKey.currentState.save();
      setState(() {
        isVerificationStarted = true;
      });
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        onCodeSent: (verificationId, [forceResendingToken]) {
          setState(() {
            this.verificationId = verificationId;
          });
        },
        onVerificationFailed: (AuthException authException) async {
          setState(() {
            error = authException.message;
          });
          await showDialog(
            barrierDismissible: true,
            context: context,
            builder: (context) => AlertDialog(
              content: Text(
                error,
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          );
          setState(() {
            isVerificationStarted = false;
          });
        },
        onVerificationCompleted: (AuthCredential credentials) async {
          await auth.signInUsingPhoneCredentials(credentials);

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => HomePage(),
            ),
          );
        },
      );
    }
  }

  _signInWithPhone() async {
    if (_otpFormKey.currentState.validate()) {
      _otpFormKey.currentState.save();
      setState(() {
        isSignInStarted = true;
      });
      try {
        await auth.signInWithPhoneNumber(
            verificationId: verificationId, smsCode: smsCode);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => HomePage(),
          ),
        );
      } on PlatformException catch (e) {
        setState(() {
          isSignInStarted = false;
        });
        showDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) => AlertDialog(
            content: Text(
              ErrorHandling.getErrorMessage(e),
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        );
      }
      setState(() {
        isSignInStarted = false;
      });
    }
  }
}
