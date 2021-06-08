import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram/screens/notifications/bloc/notifications_bloc.dart';
import 'package:flutter_instagram/screens/notifications/widgets/widgets.dart';
import 'package:flutter_instagram/widgets/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class NotificationsScreen extends StatelessWidget {
  static const String routeName = '/notifications';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NeumorphicAppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text('Notifications',
              style: Theme.of(context).textTheme.headline6),
        ),
      ),
      body: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          switch (state.status) {
            case NotificationsStatus.error:
              return CenteredText(text: state.failure.message);
            case NotificationsStatus.loaded:
              return ListView.builder(
                itemCount: state.notifications.length,
                itemBuilder: (BuildContext context, int index) {
                  final notification = state.notifications[index];
                  return NotificationTile(notification: notification);
                },
              );
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
