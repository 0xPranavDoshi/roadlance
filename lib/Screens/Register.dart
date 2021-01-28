import 'package:flutter/material.dart';
import '../Components/AuthField.dart';
import '../Database/AuthManager.dart';
import 'package:image_picker/image_picker.dart';
import 'Home.dart';
import 'dart:io';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final picker = ImagePicker();
  File _profilePic;
  Widget image = CircleAvatar(
    backgroundImage: AssetImage('assets/images/avatar.png'),
    radius: 80,
    backgroundColor: Color(0xFF6272a4),
  );
  String firstName = '';
  String lastName = '';
  String email = '';
  String phoneNumber = '';
  String password = '';

  Future<File> getProfilePic() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // setState(() {
      _profilePic = File(pickedFile.path);
      // });
      if (_profilePic != null) {
        print("ProfilePic => $_profilePic");
        return _profilePic;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // TextEditingController firstNameController = TextEditingController();
    // TextEditingController lastNameController = TextEditingController();
    // TextEditingController emailController = TextEditingController();
    // TextEditingController phoneNumberController = TextEditingController();
    // TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Color(0xFF4b4266),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: Text(
                  'Register',
                  style: TextStyle(
                    color: Color(0xFFffb86c),
                    fontFamily: 'Karla-Medium',
                    fontSize: 30,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  print("Get profile pic");
                  File profilePic = await getProfilePic();
                  setState(() {
                    image = CircleAvatar(
                      backgroundImage: FileImage(profilePic),
                      radius: 80,
                    );
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: image,
                ),
              ),
              // AuthField(
              //   controller: firstNameController,
              //   placeholder: 'First name..',
              //   isPassword: false,
              // ),
              // AuthField(
              //   controller: lastNameController,
              //   placeholder: 'Last name..',
              //   isPassword: false,
              // ),
              // AuthField(
              //   controller: emailController,
              //   placeholder: 'Email..',
              //   isPassword: false,
              // ),
              // AuthField(
              //   controller: phoneNumberController,
              //   placeholder: 'Phone number..',
              //   isPassword: false,
              // ),
              // AuthField(
              //   controller: passwordController,
              //   placeholder: 'Password..',
              //   isPassword: true,
              // ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: SizedBox(
                  width: 325,
                  height: 40,
                  child: TextField(
                    onChanged: (newText) {
                      setState(() {
                        firstName = newText;
                        print('First name is changed to => $firstName');
                      });
                    },
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Karla-Medium',
                    ),
                    obscureText: false,
                    cursorColor: Color(0xFF50fa7b),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 10),
                      hintText: 'First name..',
                      hintStyle: TextStyle(
                        fontFamily: 'Karla-Medium',
                        color: Colors.grey,
                      ),
                      fillColor: Color(0xFF4b4266),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF50fa7b),
                          width: 3.5,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF50fa7b),
                          width: 3.5,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF50fa7b),
                          width: 3.5,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: SizedBox(
                  width: 325,
                  height: 40,
                  child: TextField(
                    onChanged: (newText) {
                      setState(() {
                        lastName = newText;
                        print('Last name is changed to => $lastName');
                      });
                    },
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Karla-Medium',
                    ),
                    obscureText: false,
                    cursorColor: Color(0xFF50fa7b),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 10),
                      hintText: 'Last name..',
                      hintStyle: TextStyle(
                        fontFamily: 'Karla-Medium',
                        color: Colors.grey,
                      ),
                      fillColor: Color(0xFF4b4266),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF50fa7b),
                          width: 3.5,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF50fa7b),
                          width: 3.5,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF50fa7b),
                          width: 3.5,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: SizedBox(
                  width: 325,
                  height: 40,
                  child: TextField(
                    onChanged: (newText) {
                      setState(() {
                        email = newText;
                      });
                      print('Email is changed to => $email');
                    },
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Karla-Medium',
                    ),
                    obscureText: false,
                    cursorColor: Color(0xFF50fa7b),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 10),
                      hintText: 'Email..',
                      hintStyle: TextStyle(
                        fontFamily: 'Karla-Medium',
                        color: Colors.grey,
                      ),
                      fillColor: Color(0xFF4b4266),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF50fa7b),
                          width: 3.5,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF50fa7b),
                          width: 3.5,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF50fa7b),
                          width: 3.5,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: SizedBox(
                  width: 325,
                  height: 40,
                  child: TextField(
                    onChanged: (newText) {
                      print('Phone number is changed to => $newText');
                      setState(() {
                        phoneNumber = newText;
                      });
                    },
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Karla-Medium',
                    ),
                    obscureText: false,
                    cursorColor: Color(0xFF50fa7b),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 10),
                      hintText: 'Phone number..',
                      hintStyle: TextStyle(
                        fontFamily: 'Karla-Medium',
                        color: Colors.grey,
                      ),
                      fillColor: Color(0xFF4b4266),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF50fa7b),
                          width: 3.5,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF50fa7b),
                          width: 3.5,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF50fa7b),
                          width: 3.5,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: SizedBox(
                  width: 325,
                  height: 40,
                  child: TextField(
                    onChanged: (newText) {
                      print('Password is changed to => $newText');
                      setState(() {
                        password = newText;
                      });
                    },
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Karla-Medium',
                    ),
                    obscureText: true,
                    cursorColor: Color(0xFF50fa7b),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 10),
                      hintText: 'Password..',
                      hintStyle: TextStyle(
                        fontFamily: 'Karla-Medium',
                        color: Colors.grey,
                      ),
                      fillColor: Color(0xFF4b4266),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF50fa7b),
                          width: 3.5,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF50fa7b),
                          width: 3.5,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF50fa7b),
                          width: 3.5,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 25),
                child: SizedBox(
                  width: 125,
                  child: RaisedButton(
                    onPressed: () {
                      print(
                          "First name is $firstName\n last name is $lastName\n Email is $email\n Phone number is $phoneNumber\n Password is $password");
                      AuthManager manager = AuthManager();
                      manager.register(
                        firstName,
                        lastName,
                        email,
                        phoneNumber,
                        password,
                        _profilePic,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(
                            showWelcomePopup: true,
                            tab: 0,
                          ),
                        ),
                      );
                    },
                    color: Color(0xFF8be9fd),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text('Register'),
                  ),
                ),
              ),
              Text(
                'Already have an account?',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                child: Text(
                  'Login here!',
                  style: TextStyle(
                    color: Color(0xFF50fa7b),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
