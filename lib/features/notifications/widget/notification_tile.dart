import 'package:flutter/material.dart';
import 'package:kooginapp/core/enums/notification_type_enum.dart';
import 'package:kooginapp/core/models/notification_model.dart' as model;
import 'package:kooginapp/core/theme/theme.dart';

class NotificationTile extends StatelessWidget {
  final model.Notification notification;

  const NotificationTile({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: notification.notificationType == NotificationType.follow
          ? const Icon(
              Icons.person,
              color: Pallete.blueColor,
            )
          : notification.notificationType == NotificationType.like
              ? const Icon(Icons.favorite, color: Pallete.redColor)
              : notification.notificationType == NotificationType.repost
                  ? const Icon(Icons.subdirectory_arrow_left_outlined)
                  : null,
                  title: Text(notification.text),
    );
  }
}
