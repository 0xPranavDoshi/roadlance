import 'package:flutter/material.dart';
import './Home.dart';

class Success extends StatefulWidget {
  @override
  _SuccessState createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            tab: 1,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF4b4266),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Success!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 50,
                fontFamily: 'Karla-Medium',
              ),
            ),
            Center(
              child: Text(
                "Submitted to Police for approval!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Karla-Medium',
                ),
              ),
            ),
            Image.asset(
              "assets/images/success.gif",
              height: 125.0,
              width: 125.0,
            )
          ],
        ),
      ),
    );
  }
}
