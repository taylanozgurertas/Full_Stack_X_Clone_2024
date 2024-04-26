import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kooginapp/features/explore/view/explore_view.dart';
import 'package:kooginapp/features/notifications/views/notification_view.dart';
import 'package:kooginapp/features/posts/widgets/post_list.dart';
import '../theme/theme.dart';
import 'constants.dart';

class UIConstants {

  static AppBar appBar() {
    return AppBar(
      title: SvgPicture.asset(
        AssetsConstants.kooginLogo,
        colorFilter: const ColorFilter.mode(Pallete.greyColor, BlendMode.srcIn),
        height: 35,
      ),
      centerTitle: true,
    );
  }

  static const List<Widget> bottomTabBarPages = [
    PostList(),
    ExploreView(),
    NotificationView(),
  ];
}
