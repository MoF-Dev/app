import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookLogin facebookLogin = FacebookLogin();
  final Firestore firestore = Firestore.instance;
  FirebaseUser currentUser;

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    currentUser = user;
    return user;
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<String> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    currentUser = user;
    return user.uid;
  }

  Future<String> signInWithFacebook() async {
    var result = await facebookLogin.logIn(['email', 'public_profile']);
    var token = result.accessToken.token;
    print('signed in with facebook user: ' + result.accessToken.userId);
    var fireResult = await _firebaseAuth.signInWithCredential(
        FacebookAuthProvider.getCredential(accessToken: token));
    currentUser = fireResult.user;
    return fireResult.user.uid;
  }

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult =
        await _firebaseAuth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    currentUser = await _firebaseAuth.currentUser();
    assert(user.uid == currentUser.uid);

    print('signInWithGoogle succeeded: $user');
    return user.uid;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    currentUser = null;
  }

  void signOutFacebook() async {
    await facebookLogin.logOut();
    currentUser = null;
    print("Facebook logged out");
  }

  void signOutGoogle() async {
    await googleSignIn.signOut();
    currentUser = null;

    print("User Sign Out");
  }

  Future<String> signUp(String username, String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    firestore.collection("users").document(user.uid).setData({
      'username': username,
    });
    firestore.collection("usernames").document(username).setData({
      'uid': user.uid,
    });
    return user.uid;
  }

  Future<bool> usernameAvailable(String username) async {
    var r = await firestore.collection("usernames").document(username).get();
    return !r.exists;
  }
}

abstract class BaseAuth {
  Future<FirebaseUser> getCurrentUser();

  Future<bool> isEmailVerified();

  Future<void> sendEmailVerification();

  Future<String> signIn(String email, String password);

  Future<String> signInWithFacebook();

  Future<String> signInWithGoogle();

  Future<void> signOut();

  void signOutFacebook();

  void signOutGoogle();

  Future<String> signUp(String username, String email, String password);

  Future<bool> usernameAvailable(String username);
}
