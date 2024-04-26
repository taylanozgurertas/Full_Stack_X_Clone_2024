import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kooginapp/core/constants/appwrite_constants.dart';
import 'package:kooginapp/core/error/error_page.dart';
import 'package:kooginapp/core/models/user_model.dart';
import 'package:kooginapp/features/user_profile/controller/user_profile_controller.dart';
import 'package:kooginapp/features/user_profile/widgets/user_profile.dart';

class UserProfileView extends ConsumerWidget {
  static route(UserModel userModel) => MaterialPageRoute(
        builder: (context) {
          return UserProfileView(userModel: userModel);
        },
      );
  final UserModel userModel;
  const UserProfileView({super.key, required this.userModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel copyOfUser = userModel;
    return Scaffold(
        body: ref.watch(getLatestUserProfileDataProvider).when(
      data: (data) {
        if (data.events.contains(
            'databases.*.collections.${AppwriteConstants.usersCollection}.documents.${copyOfUser.uid}.update')) {
          copyOfUser = UserModel.fromMap(data.payload);
        }
        return UserProfile(user: copyOfUser);
      },
      error: (error, stackTrace) {
        return ErrorText(error: error.toString());
      },
      loading: () {
        return UserProfile(user: copyOfUser);
      },
    ));
  }
}
