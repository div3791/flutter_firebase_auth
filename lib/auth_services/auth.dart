import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/auth_services/user.dart';

abstract class Auth {
  Future<User> signInWithEmailAndPassword(String email, String password);

  Future<User> createUserWithEmailAndPassword(
      String name, String email, String password);

  Future<User> signInWithFacebook();

  Future<User> signInWithGoogle();

  Future<void> verifyPhoneNumber({
    @required String phoneNumber,
    @required
        Function(String verificationId, [int forceResendingToken]) onCodeSent,
    @required Function(AuthException authException) onVerificationFailed,
    @required Function(AuthCredential credential) onVerificationCompleted,
  });

  Future<User> signInUsingPhoneCredentials(AuthCredential credential);

  Future<User> signInWithPhoneNumber(
      {@required verificationId, String smsCode});

  Stream<User> get onAuthStateChange;

  Future<void> signOut();
}
