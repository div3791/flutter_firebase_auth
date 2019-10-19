import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_firebase_auth/auth_services/auth.dart';
import 'package:flutter_firebase_auth/auth_services/user.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService extends Auth {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<User> createUserWithEmailAndPassword(
      String name, String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    if (result.user != null) {
      print('user name : $name');
      UserUpdateInfo info = UserUpdateInfo();
      info.displayName = name;
      await result.user.updateProfile(info);

      return _userFromFirebaseUser(result.user);
    } else {
      return null;
    }
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    return _userFromFirebaseUser(result.user);
  }

  @override
  Future<User> signInWithFacebook() async {
    try {
      final facebookLogin = FacebookLogin();
      final result = await facebookLogin.logIn(['email']);

      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          debugPrint('Facebook Success');
          final AuthCredential credential = FacebookAuthProvider.getCredential(
              accessToken: result.accessToken.token);
          final AuthResult authResult =
              await _firebaseAuth.signInWithCredential(credential);
          if (authResult == null) {
            return null;
          } else {
            await authResult.user.getIdToken(refresh: true);
            return _userFromFirebaseUser(authResult.user);
          }
          break;
        case FacebookLoginStatus.cancelledByUser:
          debugPrint('cancelled by user');
          return null;
          break;
        case FacebookLoginStatus.error:
          debugPrint('Error by facebook');
          break;
        default:
          return null;
      }
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<User> signInWithGoogle() {
    return null;
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  @override
  // TODO: implement onAuthStateChange
  Stream<User> get onAuthStateChange => _firebaseAuth.onAuthStateChanged
      .map((FirebaseUser user) => _userFromFirebaseUser(user));

  _userFromFirebaseUser(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return User(uid: user.uid, name: user.displayName, emailId: user.email);
  }
}
