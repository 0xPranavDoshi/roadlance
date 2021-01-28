import 'package:flutter/material.dart';
import 'dart:io';

class EditProfile extends StatefulWidget {
  EditProfile({this.profilePic});

  final Widget profilePic;
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height:
            MediaQuery.of(context).size.height - AppBar().preferredSize.height,
        decoration: BoxDecoration(
          color: Color(0xFF4b4266),
          border: Border.all(
            color: Color(0xFFff79c6),
            width: 3.0,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Text(
                'Edit Profile',
                style: TextStyle(
                  color: Color(0xFF50fa7b),
                  fontFamily: 'Karla-Medium',
                  fontSize: 26,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      print("Changing profile pic");
                      // File profilePic = await changeProfilePic();
                      // setState(() {
                      //   profilePicWidget = CircleAvatar(
                      //     backgroundImage: widget.profilePic,
                      //     radius: 80,
                      //   );
                      // });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 30, top: 30),
                      child: widget.profilePic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
