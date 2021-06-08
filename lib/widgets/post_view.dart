import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/extensions/extensions.dart';
import 'package:flutter_instagram/models/models.dart';
import 'package:flutter_instagram/screens/screens.dart';
import 'package:flutter_instagram/widgets/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class PostView extends StatelessWidget {
  final Post post;
  final bool isLiked;
  final VoidCallback onLike;
  final bool recentlyLiked;

  const PostView({
    Key key,
    @required this.post,
    @required this.isLiked,
    @required this.onLike,
    this.recentlyLiked = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
                ProfileScreen.routeName,
                arguments: ProfileScreenArgs(userId: post.author.id),
              ),
              child: Row(
                children: [
                  UserProfileImage(
                    radius: 18.0,
                    profileImageUrl: post.author.profileImageUrl,
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(post.author.username,
                        style: Theme.of(context).textTheme.subtitle1),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onDoubleTap: onLike,
            child: Neumorphic(
              style: NeumorphicStyle(
                border: NeumorphicBorder(
                  color: Color(0x33000000),
                  width: 0.8,
                ),
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                shape: NeumorphicShape.flat,
                depth: 6,
                intensity: 0.75,
                lightSource: LightSource.topLeft,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: CachedNetworkImage(
                  height: MediaQuery.of(context).size.height / 2.25,
                  width: double.infinity,
                  imageUrl: post.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Neumorphic(
                  style: NeumorphicStyle(
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(40)),
                    shape: NeumorphicShape.concave,
                    depth: 4,
                    intensity: 0.75,
                    surfaceIntensity: 0.75,
                    lightSource: LightSource.topLeft,
                  ),
                  child: IconButton(
                    icon: isLiked
                        ? const Icon(Icons.favorite, color: Colors.red)
                        : const Icon(Icons.favorite_outline),
                    onPressed: onLike,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Neumorphic(
                  style: NeumorphicStyle(
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(40)),
                    shape: NeumorphicShape.concave,
                    depth: 4,
                    intensity: 0.75,
                    surfaceIntensity: 0.75,
                    lightSource: LightSource.topLeft,
                  ),
                  child: IconButton(
                    icon: const Icon(FontAwesomeIcons.comments),
                    onPressed: () => Navigator.of(context).pushNamed(
                      CommentsScreen.routeName,
                      arguments: CommentsScreenArgs(post: post),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '${recentlyLiked ? post.likes + 1 : post.likes} likes',
                  style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4.0),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: post.author.username,
                        style: GoogleFonts.sourceSansPro(
                            fontWeight: FontWeight.w600),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(text: post.caption),
                    ],
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  post.date.timeAgo(),
                  style: GoogleFonts.sourceSansPro(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
