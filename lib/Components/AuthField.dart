import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AuthField extends StatefulWidget {
  AuthField({
    @required this.controller,
    @required this.placeholder,
    @required this.isPassword,
  });

  final String placeholder;
  final TextEditingController controller;
  final bool isPassword;
  @override
  _AuthFieldState createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: SizedBox(
        width: 325,
        height: 40,
        child: TextField(
          controller: widget.controller,
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Karla-Medium',
          ),
          obscureText: widget.isPassword,
          cursorColor: Color(0xFF50fa7b),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(top: 10),
            hintText: widget.placeholder,
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
    );
  }
}
