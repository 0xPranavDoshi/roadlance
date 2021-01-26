import 'package:flutter/material.dart';
import '../Models/AppUser.dart';

class UserCard extends StatelessWidget {
  UserCard({this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Color(0xFF151430),
          border: Border.all(
            color: Color(
              0XFFff79c6,
            ),
            width: 3.0,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${user.currentBalance}',
                    style: TextStyle(
                      color: Color(0xFF50fa7b),
                      fontSize: 17,
                    ),
                  ),
                  Text(' | ',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  Text(
                    '${user.displayName} ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontFamily: 'Karla-Medium',
                    ),
                    textAlign: TextAlign.center,
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
