import 'package:flutter/material.dart';

class DisplayBox extends StatelessWidget {
  DisplayBox({
    this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: SizedBox(
        width: 200,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xFF070c29),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              text,
              style: TextStyle(
                color: Color(0xFF50fa7b),
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
