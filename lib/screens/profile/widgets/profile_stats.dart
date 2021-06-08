import 'package:flutter/material.dart';
import 'package:flutter_instagram/screens/profile/widgets/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileStats extends StatelessWidget {
  final bool isCurrentUser;
  final bool isFollowing;
  final int posts;
  final int followers;
  final int following;

  const ProfileStats({
    Key key,
    @required this.isCurrentUser,
    @required this.isFollowing,
    @required this.posts,
    @required this.followers,
    @required this.following,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _Stats(count: posts, label: 'posts'),
                    _Stats(count: 1122, label: 'followers'),
                    _Stats(count: 973, label: 'following'),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: ProfileButton(
                    isCurrentUser: isCurrentUser,
                    isFollowing: isFollowing,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Stats extends StatelessWidget {
  final int count;
  final String label;

  const _Stats({
    Key key,
    @required this.count,
    @required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: GoogleFonts.sourceSansPro(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: Colors.black54
          ),
        ),
        Text(
          label,
          style: GoogleFonts.sourceSansPro(color: Colors.black54),
        ),
      ],
    );
  }
}
