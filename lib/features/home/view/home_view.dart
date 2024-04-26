import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kooginapp/core/constants/constants.dart';
import 'package:kooginapp/core/providers/providers.dart';
import 'package:kooginapp/core/theme/pallete.dart';
import 'package:kooginapp/features/home/widget/side_drawer.dart';
import 'package:kooginapp/features/posts/views/create_post_view.dart';

class HomeView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const HomeView(),
      );

  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  int _page = 0;

  void onPageChange(int index) {
    setState(() {
      _page = index;
    });
  }

  onCreatePost() {
    Navigator.push(context, CreatePostScreen.route());
  }

  @override
  Widget build(BuildContext context) {
    final appThemeState = ref.watch(appThemeStateNotifier);
    return Scaffold(
      appBar: _page == 0
          ? AppBar(
              title: SvgPicture.asset(
                AssetsConstants.kooginLogo,
                colorFilter: ColorFilter.mode(
                    appThemeState.isDarkModeEnabled ? Pallete.whiteColor : Pallete.blackColor, BlendMode.srcIn),
                height: 35,
              ),
              centerTitle: true,
            )
          : null,
      body: IndexedStack(index: _page, children: UIConstants.bottomTabBarPages),
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: onCreatePost,
        child: const Icon(Icons.add, color: Pallete.blackColor),
      ),
      bottomNavigationBar: CupertinoTabBar(
        iconSize: 25,
        onTap: onPageChange,
        currentIndex: _page,
        backgroundColor: appThemeState.isDarkModeEnabled ? Pallete.blackColor : Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: _page == 0
                ? const Icon(Icons.home, color: Pallete.blueColor)
                : const Icon(
                    Icons.home_outlined,
                  ),
          ),
          BottomNavigationBarItem(
            icon: _page == 1
                ? const Icon(Icons.search, color: Pallete.blueColor)
                : const Icon(
                    Icons.search_outlined,
                  ),
          ),
          BottomNavigationBarItem(
            icon: _page == 2
                ? const Icon(Icons.notifications, color: Pallete.blueColor)
                : const Icon(
                    Icons.notifications_outlined,
                  ),
          ),
        ],
      ),
      drawer: const SideDrawer(),
    );
  }
}
