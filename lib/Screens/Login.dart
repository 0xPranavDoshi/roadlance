import 'package:RoadLance/Database/AuthManager.dart';
import 'Home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Components/AuthField.dart';
import 'package:flutter/material.dart';
import 'Register.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController isPasswordController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  String errorMessage = 'Unknown Error';
  bool errorVisible = false;

  @override
  void initState() {
    super.initState();
    if (auth.currentUser != null) {
      Future.delayed(Duration.zero, () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      });
    }
  }

  void getPhoneNumber() {
    TextEditingController phoneNumberController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFF4b4266),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          content: Builder(
            builder: (context) {
              // Get available height and width of the build area of this widget. Make a choice depending on the size.
              return Container(
                child: AuthField(
                  controller: phoneNumberController,
                  isPassword: false,
                  placeholder: 'Phone Number',
                ),
              );
            },
          ),
          actions: [
            FlatButton(
              onPressed: () {
                GoogleSignIn auth = GoogleSignIn();
                auth.signOut();
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Karla-Regular',
                  fontSize: 17.5,
                ),
              ),
            ),
            FlatButton(
              onPressed: () async {
                FocusScope.of(context).unfocus();
                AuthManager manager = AuthManager();
                FirebaseAuth auth = FirebaseAuth.instance;
                User currentUser = auth.currentUser;
                await manager
                    .createGoogleAuthUser(
                  currentUser,
                  phoneNumberController.text,
                )
                    .then(
                  (_) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(
                          tab: 0,
                        ),
                      ),
                    );
                  },
                );
              },
              child: Text(
                'Sign Up',
                style: TextStyle(
                  color: Color(0xFF8be9fd),
                  fontFamily: 'Karla-Medium',
                  fontSize: 17.5,
                ),
              ),
              // color: Color(0xFF8be9fd),
              // shape: RoundedRectangleBorder(
              // borderRadius: BorderRadius.circular(15)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF4b4266),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25.0),
                    child: Text(
                      'RoadLance',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Karla-Medium',
                        fontSize: 30,
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.asset(
                      'assets/images/app-icon.png',
                      width: 200,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    width: 250,
                    height: 45,
                    child: signInButton(),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  AuthField(
                    controller: emailAddressController,
                    placeholder: 'Email',
                    isPassword: false,
                  ),
                  AuthField(
                    controller: isPasswordController,
                    placeholder: 'Password',
                    isPassword: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: RaisedButton(
                      onPressed: () {
                        AuthManager manager = AuthManager();
                        manager.login(
                          emailAddressController.text,
                          isPasswordController.text,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(
                              showWelcomePopup: false,
                              tab: 0,
                            ),
                          ),
                        );
                      },
                      color: Color(0xFF8be9fd),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text('Login'),
                    ),
                  ),
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  GestureDetector(
                    child: Text(
                      'Register here!',
                      style: TextStyle(
                        color: Color(0xFF50fa7b),
                        fontSize: 15,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Register(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget signInButton() {
    return FlatButton(
      splashColor: Colors.white,
      color: Colors.white,
      onPressed: () async {
        AuthManager manager = AuthManager();
        if (await manager.signInWithGoogle() != 'Failed') {
          print("Google sign in worked");
          getPhoneNumber();
        } else {
          print("Google sign in failed");
        }
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage("assets/images/google-icon.png"),
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign In With Google',
                style: TextStyle(
                  fontSize: 17.5,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
