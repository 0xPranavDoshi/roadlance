import 'package:flutter/material.dart';
import '../../Database/AuthManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Database/DbManager.dart';
import '../Login.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../EditProfile.dart';

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  int currentBalance = 0;
  String fullName = '';
  String profilePicUrl;
  Widget profilePicWidget = CircleAvatar(
    backgroundImage: AssetImage('assets/images/avatar.png'),
    radius: 80,
    backgroundColor: Color(0xFF6272a4),
  );
  int approvedPosts = 0;
  int declinedPosts = 0;
  final picker = ImagePicker();
  File _profilePic;

  @override
  void initState() {
    super.initState();
    setCurrentBalance();
    fullName = getDisplayName();
    Future.delayed(Duration.zero, () async {
      approvedPosts = await getApprovedPosts();
      declinedPosts = await getDeclinedPosts();
      profilePicUrl = await getProfilePic();
      setState(() {
        if (profilePicUrl != null) {
          profilePicWidget = CircleAvatar(
            backgroundImage: NetworkImage(profilePicUrl),
            radius: 80,
          );
        }
      });
    });
  }

  Future<File> changeProfilePic() async {
    DatabaseManager manager = DatabaseManager();
    FirebaseAuth auth = FirebaseAuth.instance;

    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // setState(() {
      _profilePic = File(pickedFile.path);
      // });
      if (_profilePic != null) {
        print("ProfilePic => $_profilePic");
        manager.saveProfilePic(auth.currentUser.uid, _profilePic);
        return _profilePic;
      }
    }
    return null;
  }

  Future<int> getDeclinedPosts() async {
    DatabaseManager manager = DatabaseManager();
    FirebaseAuth auth = FirebaseAuth.instance;
    return await manager.getDeclinedPosts(auth.currentUser.uid);
  }

  Future<int> getApprovedPosts() async {
    DatabaseManager manager = DatabaseManager();
    FirebaseAuth auth = FirebaseAuth.instance;
    return await manager.getApprovedPosts(auth.currentUser.uid);
  }

  Future<String> getProfilePic() async {
    DatabaseManager manager = DatabaseManager();
    FirebaseAuth auth = FirebaseAuth.instance;
    return await manager.getProfilePic(auth.currentUser.uid);
  }

  void setCurrentBalance() async {
    DatabaseManager manager = DatabaseManager();
    int updatedBalance = await manager.getUserBalance();
    setState(() {
      currentBalance = updatedBalance;
    });
  }

  String getDisplayName() {
    FirebaseAuth auth = FirebaseAuth.instance;

    FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data();
        print('Document data: $data');
        setState(() {
          fullName = data['FullName'];
        });
      } else {
        print('Document does not exist on the database');
      }
    });

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF4b4266),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Color(0xFF282a36),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (context) => EditProfile(
                                  profilePic: profilePicWidget,
                                ),
                              ).whenComplete(() {
                                print("Modal closed!");
                              });
                            },
                            child: Text(
                              'edit',
                              style: TextStyle(
                                color: Color(0xFF8be9fd),
                                fontSize: 21,
                                fontFamily: 'Karla-Medium',
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () async {
                            print("Changing profile pic");
                            File profilePic = await changeProfilePic();
                            setState(() {
                              profilePicWidget = CircleAvatar(
                                backgroundImage: FileImage(profilePic),
                                radius: 80,
                              );
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 30, top: 30),
                            child: profilePicWidget,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      fullName,
                      style: TextStyle(
                        color: Color(0xFF50fa7b),
                        fontSize: 23,
                        fontFamily: 'Karla-Medium',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: Text(
                      'Current Balance : $currentBalance',
                      style: TextStyle(
                        color: Color(0xFF50fa7b),
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF44475a),
                border: Border.all(
                  color: Color(0xFF282a36),
                ),
              ),
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Text(
                          'Approved posts: ',
                          style: TextStyle(
                            fontFamily: 'Karla-Medium',
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '$approvedPosts',
                          style: TextStyle(
                            fontFamily: 'Karla-Medium',
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width / 4),
                  Container(
                    child: Row(
                      children: [
                        Text(
                          'Declined posts: ',
                          style: TextStyle(
                            fontFamily: 'Karla-Medium',
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '$declinedPosts',
                          style: TextStyle(
                            fontFamily: 'Karla-Medium',
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            FlatButton.icon(
              onPressed: () async {
                AuthManager manager = AuthManager();
                await manager.signOut().then(
                  (_) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Login(),
                      ),
                    );
                  },
                );
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.amber,
              ),
              label: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 20.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
