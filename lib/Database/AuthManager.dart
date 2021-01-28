import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import './DbManager.dart';
import 'dart:io';

class AuthManager {
  FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseManager manager = DatabaseManager();

  Future<String> login(String email, String password) async {
    try {
      // ignore: unused_local_variable
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return e.message;
    }
  }

  Future<String> register(String firstName, String lastName, String email,
      String password, String phoneNumber, dynamic profilePic) async {
    print("Regisering user...");
    await auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((UserCredential cred) async {
      print("Successfully registered user");
      String fullName = firstName + " " + lastName;
      await manager.saveUserData(
          firstName, lastName, fullName, email, phoneNumber);
      await manager.saveProfilePic(cred.user.uid, profilePic);
      print("Success!");
      return 'Success';
    }).catchError((err) {
      print("ERROR IS $err");
      return err;
    });
    return null;
  }

  Future<String> signInWithGoogle() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User user = authResult.user;
    if (user != null) {
      return 'Success';
    } else {
      return 'Failed';
    }
  }

  Future<void> createGoogleAuthUser(User user, String phoneNumber) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference ref = firestore.collection('Users').doc(user.uid);
    ref.set(
      {
        'FullName': user.displayName,
        'Email': user.email,
        'PhoneNumber': phoneNumber,
        'CurrentBalance': 0,
        'FirstMediaTime': null,
      },
    );
  }

  Future<User> getCurrentUser() async {
    return auth.currentUser;
  }

  Future signOut() async {
    await auth.signOut();
  }
}
