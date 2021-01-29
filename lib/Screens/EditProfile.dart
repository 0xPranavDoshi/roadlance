import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import './Tabs/ProfileTab.dart';
import '../Database/DbManager.dart';
import 'dart:io';

class EditProfile extends StatefulWidget {
  EditProfile({this.profilePic, this.fullName});

  final Widget profilePic;
  final String fullName;
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  Widget widgetProfilePic;
  File _profilePic;
  final picker = ImagePicker();
  String name;
  bool loadingButtonVisible = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      widgetProfilePic = widget.profilePic;
    });
  }

  Future changeProfilePic() async {
    DatabaseManager manager = DatabaseManager();
    FirebaseAuth auth = FirebaseAuth.instance;

    print("ProfilePic => $_profilePic");
    await manager.saveProfilePic(auth.currentUser.uid, _profilePic);
  }

  Future changeUsername() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    DatabaseManager manager = DatabaseManager();
    await manager.changeUsername(auth.currentUser.uid, name);
  }

  Future<File> changeProfilePicTemp() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _profilePic = File(pickedFile.path);
      if (_profilePic != null) {
        print("ProfilePic => $_profilePic");
        return _profilePic;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF4b4266),
      appBar: AppBar(
        backgroundColor: Color(0xFF312c42),
        centerTitle: true,
        title: Text('Edit Profile'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileTab(),
                ),
              );
            }),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: GestureDetector(
                      onTap: () async {
                        print("Changing profile pic");
                        File profilePic = await changeProfilePicTemp();
                        setState(() {
                          widgetProfilePic = CircleAvatar(
                            backgroundImage: FileImage(profilePic),
                            radius: 80,
                          );
                        });
                      },
                      child: Container(width: 110, child: widgetProfilePic),
                    ),
                  ),
                  Positioned(
                    top: 35,
                    right: 12,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          Icons.add_a_photo,
                          color: Colors.grey,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 35),
              child: TextFormField(
                onChanged: (newText) {
                  setState(() {
                    name = newText;
                    print("Name is now $name");
                  });
                },
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      // color: Color(0xFF8be9fd),
                      color: Colors.white,
                    ),
                  ),
                ),
                textAlign: TextAlign.center,
                initialValue: widget.fullName,
                style: TextStyle(
                  color: Color(0xFF50fa7b),
                  fontFamily: 'Karla-Medium',
                  fontSize: 22,
                ),
              ),
            ),
            Visibility(
              visible: loadingButtonVisible,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Container(
                    width: 50, child: Image.asset('assets/images/loading.gif')),
              ),
            ),
            RaisedButton(
              onPressed: () async {
                setState(() {
                  loadingButtonVisible = true;
                });
                print("Changing profile pic");
                await changeProfilePic();
                print("Changing username");
                if (name != null) {
                  await changeUsername();
                }
                setState(() {
                  loadingButtonVisible = false;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileTab(),
                  ),
                );
              },
              color: Color(0xFF8be9fd),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                'Save Changes',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Karla-Medium',
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
