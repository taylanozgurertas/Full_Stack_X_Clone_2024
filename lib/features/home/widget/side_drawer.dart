import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kooginapp/core/common/loading_page.dart';
import 'package:kooginapp/core/constants/app_texts.dart';
import 'package:kooginapp/core/theme/pallete.dart';
import 'package:kooginapp/features/auth/controller/auth_controller.dart';
import 'package:kooginapp/features/home/widget/switch_theme.dart';
import 'package:kooginapp/features/user_profile/controller/user_profile_controller.dart';
import 'package:kooginapp/features/user_profile/view/user_profile_view.dart';

import '../../../core/constants/constants.dart';
import '../../../core/providers/providers.dart';

class SideDrawer extends ConsumerWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    final appThemeState = ref.watch(appThemeStateNotifier);
    if (currentUser == null) {
      return const Loader();
    }
    return SafeArea(
      child: Drawer(
        backgroundColor: appThemeState.isDarkModeEnabled ? Pallete.blackColor : Pallete.whiteColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SvgPicture.asset(
                AssetsConstants.kooginLogo,
                colorFilter: ColorFilter.mode(
                    appThemeState.isDarkModeEnabled ? Pallete.whiteColor : Pallete.blackColor, BlendMode.srcIn),
                height: 35,
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.person,
              ),
              title: const Text(
                AppTexts.myProfile,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  UserProfileView.route(
                    currentUser,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.verified,
              ),
              title: const Text(AppTexts.vipUser, style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                //showSnackBar(context, 'Soon this feature will come');

                /*
                
                 */
                //we need to add payment and if the payment is succesfull logic above and then this:
                ref.read(userProfileControllerProvider.notifier).updateUserProfile(
                    userModel: currentUser.copyWith(
                      isTwitterBlue: true,
                    ),
                    context: context,
                    bannerFile: null,
                    profileFile: null);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
              ),
              title: const Text(AppTexts.logout, style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                ref.read(authControllerProvider.notifier).logout(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
              ),
              title: const Row(
                children: [
                  Text(
                    AppTexts.enableDarkMode,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  DarkModeSwitch(),
                ],
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
