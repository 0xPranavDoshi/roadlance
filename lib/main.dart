import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './Screens/Login.dart';
import './Screens/Loading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(RoadLance());
}

class RoadLance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Roadlance',
      home: Scaffold(
        body: LoadingScreen(),
      ),
    );
  }
}
