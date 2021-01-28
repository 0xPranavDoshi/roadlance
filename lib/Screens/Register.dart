import 'package:flutter/material.dart';
import '../Components/AuthField.dart';
import '../Database/AuthManager.dart';
import 'package:image_picker/image_picker.dart';
import 'Home.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

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
    backgroundColor: Color(0xFF324985),
  );

  Future<File> getProfilePic() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profilePic = File(pickedFile.path);
      });
      if (_profilePic != null) {
        print("ProfilePic => $_profilePic");
        return _profilePic;
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController phoneNumberController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

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
              AuthField(
                controller: firstNameController,
                placeholder: 'First name..',
                isPassword: false,
              ),
              AuthField(
                controller: lastNameController,
                placeholder: 'Last name..',
                isPassword: false,
              ),
              AuthField(
                controller: emailController,
                placeholder: 'Email..',
                isPassword: false,
              ),
              AuthField(
                controller: phoneNumberController,
                placeholder: 'Phone number..',
                isPassword: false,
              ),
              AuthField(
                controller: passwordController,
                placeholder: 'Password..',
                isPassword: true,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 25),
                child: SizedBox(
                  width: 125,
                  child: RaisedButton(
                    onPressed: () {
                      AuthManager manager = AuthManager();
                      manager.register(
                        firstNameController.text,
                        lastNameController.text,
                        emailController.text,
                        passwordController.text,
                        phoneNumberController.text,
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
