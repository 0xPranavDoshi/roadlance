import 'package:flutter/material.dart';
import '../../Database/AuthManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Database/DbManager.dart';
import '../Login.dart';

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  int currentBalance = 0;
  String fullName = '';

  @override
  void initState() {
    super.initState();
    setCurrentBalance();
    fullName = getDisplayName();
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Text(
                fullName,
                style: TextStyle(
                  color: Color(0xFF8be9fd),
                  fontSize: 23,
                  fontFamily: 'Karla-Medium',
                ),
              ),
            ),
            Text(
              'Current Balance : $currentBalance',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
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
