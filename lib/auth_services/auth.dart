import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_auth/auth_services/user.dart';

abstract class Auth {
  Future<User> signInWithEmailAndPassword(
      String email, String password);

  Future<User> createUserWithEmailAndPassword(
      String name, String email, String password);

  Future<User> signInWithFacebook();

  Future<User> signInWithGoogle();

  Stream<User> get onAuthStateChange;

  Future<void> signOut();
}
