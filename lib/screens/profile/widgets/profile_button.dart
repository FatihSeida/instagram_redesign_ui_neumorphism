import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram/screens/profile/bloc/profile_bloc.dart';
import 'package:flutter_instagram/screens/screens.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileButton extends StatelessWidget {
  final bool isCurrentUser;
  final bool isFollowing;

  const ProfileButton({
    Key key,
    @required this.isCurrentUser,
    @required this.isFollowing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isCurrentUser
        ? InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(EditProfileScreen.routeName,
                  arguments: EditProfileScreenArgs(context: context));
            },
            child: Neumorphic(
              style: NeumorphicStyle(
                shape: NeumorphicShape.flat,
                depth: 5,
                intensity: 0.75,
                lightSource: LightSource.topLeft,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
              ),
              child: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color(0xFF0059D6),
                                        Color(0xFF04BFBF),
                        ],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Text(
                    'Edit Profile',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.sourceSansPro(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  )),
            ),
          )
        : FlatButton(
            onPressed: () => isFollowing
                ? context.read<ProfileBloc>().add(ProfileUnfollowUser())
                : context.read<ProfileBloc>().add(ProfileFollowUser()),
            color:
                isFollowing ? Colors.grey[300] : Theme.of(context).primaryColor,
            textColor: isFollowing ? Colors.black : Colors.white,
            child: Text(
              isFollowing ? 'Unfollow' : 'Follow',
              style: TextStyle(fontSize: 16.0),
            ),
          );
  }
}
