import 'package:firebase_auth/firebase_auth.dart';
import './DbManager.dart';

class AuthManager {
  FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseManager manager = DatabaseManager();

  Future<String> login(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future<String> register(String firstName, String lastName, String email,
      String password, String phoneNumber) async {
    print("Regisering user...");
    await auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((UserCredential cred) {
      print("Successfully registered user");
      String fullName = firstName + " " + lastName;
      manager.saveUserData(firstName, lastName, fullName, email, phoneNumber);
    }).catchError((err) {
      print(err);
      return err;
    });
    return null;
  }

  Future<User> getCurrentUser() async {
    return auth.currentUser;
  }

  Future signOut() async {
    await auth.signOut();
  }
}
