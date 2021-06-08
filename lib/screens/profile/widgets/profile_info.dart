import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileInfo extends StatelessWidget {
  final String username;
  final String bio;

  const ProfileInfo({
    Key key,
    @required this.username,
    @required this.bio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          username,
          style: GoogleFonts.sourceSansPro(
            color: Colors.black54,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          bio,
          style: GoogleFonts.sourceSansPro(
            fontSize: 16.0,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
