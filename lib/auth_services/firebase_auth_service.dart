import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          throw StateError('Facebook SignIn aborted by user');
          break;
        case FacebookLoginStatus.error:
          throw StateError('Something went wrong');
          break;
        default:
          return null;
      }
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount signInAccount = await googleSignIn.signIn();

      if (signInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await signInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        final AuthResult authResult =
            await _firebaseAuth.signInWithCredential(credential);

        if (authResult == null) {
          return null;
        } else {
          return await _userFromFirebaseUser(authResult.user);
        }
      } else {
        throw StateError('Google SignIn aborted by user');
      }
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> verifyPhoneNumber({
    @required String phoneNumber,
    @required
        Function(String verificationId, [int forceResendingToken]) onCodeSent,
    @required Function(AuthException authException) onVerificationFailed,
    @required Function(AuthCredential credential) onVerificationCompleted,
  }) async {
    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 5),
        verificationCompleted: onVerificationCompleted,
        verificationFailed:
            onVerificationFailed, //(AuthException authException) {},
        codeSent:
            onCodeSent, //(String verificationId, [int forceResendingToken]) {}
        codeAutoRetrievalTimeout: (String verificationId) {});
  }

  Future<User> signInUsingPhoneCredentials(AuthCredential credential) async {
    AuthResult result = await _firebaseAuth.signInWithCredential(credential);
    if (result != null) {
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    }
    return null;
  }

  Future<User> signInWithPhoneNumber(
      {@required verificationId, String smsCode}) async {
    FirebaseUser user;
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final AuthResult result =
          await _firebaseAuth.signInWithCredential(credential);
      user = result.user;
    } on PlatformException catch (e) {
      rethrow;
    }
    return _userFromFirebaseUser(user);
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    if (googleSignIn != null) {
      await googleSignIn.signOut();
    }

    final facebookLogin = FacebookLogin();
    if (facebookLogin != null) {
      await facebookLogin.logOut();
    }
    return await _firebaseAuth.signOut();
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
