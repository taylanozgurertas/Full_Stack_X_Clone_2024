import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kooginapp/core/constants/app_texts.dart';
import 'package:kooginapp/core/constants/constants.dart';
import 'package:kooginapp/core/error/error_page.dart';
import 'package:kooginapp/features/auth/controller/auth_controller.dart';
import 'package:kooginapp/features/notifications/controller/notification_controller.dart';
import 'package:kooginapp/core/models/notification_model.dart' as model;
import 'package:kooginapp/features/notifications/widget/notification_tile.dart';

import '../../../core/common/loading_page.dart';

class NotificationView extends ConsumerWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppTexts.notifications),
      ),
      body: currentUser == null
          ? const Loader()
          : ref.watch(getNotificationsProvider(currentUser.uid)).when(
                data: (notifications) {
                  return ref.watch(getLatestNotificationProvider).when(
                        data: (data) {
                          if (data.events.contains(
                            'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.notificationsCollection}.documents.*.create',
                          )) {
                            final latestNotif = model.Notification.fromMap(data.payload);
                            if (latestNotif.uid == currentUser.uid) {
                              notifications.insert(0, latestNotif);
                            }
                          }

                          return ListView.builder(
                            itemCount: notifications.length,
                            itemBuilder: (context, index) {
                              final notification = notifications[index];

                              return NotificationTile(notification: notification);
                            },
                          );
                        },
                        error: (error, stackTrace) => ErrorText(error: error.toString()),
                        loading: () {
                          return ListView.builder(
                            itemCount: notifications.length,
                            itemBuilder: (context, index) {
                              final notification = notifications[index];
                              return NotificationTile(notification: notification);
                            },
                          );
                        },
                      );
                },
                error: (error, stackTrace) => ErrorText(error: error.toString()),
                loading: () => const Loader(),
              ),
    );
  }
}
