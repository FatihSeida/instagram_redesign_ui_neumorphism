import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/enums/enums.dart';

import 'package:flutter_instagram/models/models.dart';
import 'package:flutter_instagram/screens/screens.dart';
import 'package:flutter_instagram/widgets/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';

class NotificationTile extends StatelessWidget {
  final Notif notification;

  const NotificationTile({
    Key key,
    @required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Neumorphic(
        style: NeumorphicStyle(
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(40)),
          shape: NeumorphicShape.concave,
          depth: 3,
          intensity: 0.75,
          surfaceIntensity: 0.75,
          lightSource: LightSource.topLeft,
        ),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: UserProfileImage(
            radius: 18.0,
            profileImageUrl: notification.fromUser.profileImageUrl,
          ),
        ),
      ),
      title: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: notification.fromUser.username,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            const TextSpan(text: ' '),
            TextSpan(text: _getText(notification)),
          ],
        ),
      ),
      subtitle: Text(
        DateFormat.yMd().add_jm().format(notification.date),
        style: TextStyle(
          color: Colors.grey[600],
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: _getTrailing(context, notification),
      onTap: () => Navigator.of(context).pushNamed(
        ProfileScreen.routeName,
        arguments: ProfileScreenArgs(userId: notification.fromUser.id),
      ),
    );
  }

  String _getText(Notif notification) {
    switch (notification.type) {
      case NotifType.like:
        return 'liked your post.';
      case NotifType.comment:
        return 'commented on your post.';
      case NotifType.follow:
        return 'followed you.';
      default:
        return '';
    }
  }

  Widget _getTrailing(BuildContext context, Notif notif) {
    if (notification.type == NotifType.like ||
        notification.type == NotifType.comment) {
      return GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(
          CommentsScreen.routeName,
          arguments: CommentsScreenArgs(post: notification.post),
        ),
        child: Neumorphic(
          style: NeumorphicStyle(
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
            shape: NeumorphicShape.concave,
            depth: 3,
            intensity: 0.75,
            surfaceIntensity: 0.75,
            lightSource: LightSource.topLeft,
          ),
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: CachedNetworkImage(
                height: 60.0,
                width: 60.0,
                imageUrl: notification.post.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    } else if (notification.type == NotifType.follow) {
      return Neumorphic(
        style: NeumorphicStyle(
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(40)),
          shape: NeumorphicShape.concave,
          depth: 3,
          intensity: 0.75,
          surfaceIntensity: 0.75,
          lightSource: LightSource.topLeft,
        ),
        child: const SizedBox(
          height: 60.0,
          width: 60.0,
          child: Icon(Icons.person_add),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
