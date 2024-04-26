import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kooginapp/core/constants/appwrite_constants.dart';

import '../theme/theme.dart';

final appwriteClientProvider = Provider((ref) {
  //! IT REACHES THE APPWRITE CLIENT
  Client client = Client();
  return client
      .setEndpoint(AppwriteConstants.endPoint)
      .setProject(AppwriteConstants.projectId)
      .setSelfSigned(status: true);
});

//! its interacting and watches any changes for client ACCOUNT
final appwriteAccountProvider = Provider(
  (ref) {
    final client = ref.watch(appwriteClientProvider);
    return Account(client);
  },
);

//! its interacting and watches any changes for client DATABASE
final appwriteDatabaseProvider = Provider((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Databases(client);
});

//! //! its interacting and watches any changes for client STORAGE
final appWriteStorageProvider = Provider((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Storage(client);
});

//! its for stream (to show realtime post thanks to the appwrite)

final appWriteRealTimeProvider = Provider((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Realtime(client);
});

final appWriteRealTimeProviderForPosts = Provider((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Realtime(client);
});

final appWriteRealTimeProviderForUsers = Provider((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Realtime(client);
});

final appWriteRealTimeProviderForNotifications = Provider((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Realtime(client);
});

final appThemeStateNotifier = ChangeNotifierProvider((ref) {
  return AppThemeState();
});
