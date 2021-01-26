import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../Components/PostCard.dart';
import '../../Models/Post.dart';
import '../../Database/AuthManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Leaderboard.dart';
import '../../Models/AppUser.dart';
import '../../Components/UserCard.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  User currentUser;

  Future setCurrentUser() async {
    AuthManager manager = AuthManager();
    User user = await manager.getCurrentUser();
    setState(() {
      currentUser = user;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await setCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser != null) {
      return Scaffold(
        backgroundColor: Color(0xFF4b4266),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Leaderboard(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF44475a),
                      border: Border(
                        top: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                        bottom: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Leaderboard",
                          style: TextStyle(color: Colors.white, fontSize: 23),
                        ),
                        Icon(
                          Icons.arrow_right,
                          color: Colors.white,
                          size: 50,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Recent Uploads",
                    style: TextStyle(color: Colors.white, fontSize: 23),
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  height: 750,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Users')
                        .doc(currentUser.uid)
                        .collection('Posts')
                        .orderBy('UploadTime', descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData || currentUser == null) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: snapshot.data.docs.map((
                            QueryDocumentSnapshot document,
                          ) {
                            var data = document.data();
                            return PostCard(
                              post: Post(
                                violation: data['Violation'],
                                description: data['Description'],
                                status: data['Status'],
                                mediaUrls: data['Media-Urls'],
                                mediaDetails: data['Media-Details'],
                                numberPlate: data['NumberPlate'],
                                latitude: data['Latitude'],
                                longitude: data['Longitude'],
                                uploadTime: data['UploadTime'],
                              ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return CircularProgressIndicator();
    }
  }
}
