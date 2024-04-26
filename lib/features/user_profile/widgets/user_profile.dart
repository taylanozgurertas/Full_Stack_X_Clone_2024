import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kooginapp/core/common/loading_page.dart';
import 'package:kooginapp/core/constants/app_texts.dart';
import 'package:kooginapp/core/error/error_page.dart';
import 'package:kooginapp/core/models/user_model.dart';
import 'package:kooginapp/core/theme/pallete.dart';
import 'package:kooginapp/features/auth/controller/auth_controller.dart';
import 'package:kooginapp/features/posts/views/post_reply_view.dart';
import 'package:kooginapp/features/posts/widgets/post_card.dart';
import 'package:kooginapp/features/user_profile/controller/user_profile_controller.dart';
import 'package:kooginapp/features/user_profile/view/edit_profile_view.dart';
import 'package:kooginapp/features/user_profile/widgets/follow_count.dart';

import '../../../core/constants/constants.dart';

class UserProfile extends ConsumerWidget {
  final UserModel user;
  const UserProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;

    return currentUser == null
        ? const Loader()
        : NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 150,
                  floating: true,
                  snap: true,
                  flexibleSpace: Stack(
                    children: [
                      Positioned.fill(
                        child: user.bannerPic.isEmpty
                            ? Container(
                                color: Pallete.searchBarColor,
                              )
                            : Image.network(
                                user.bannerPic,
                                fit: BoxFit.fitWidth,
                              ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                                user.profilePic == '' ? AssetsConstants.noProfilePicture : user.profilePic),
                            radius: 45,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        margin: const EdgeInsets.all(20),
                        child: OutlinedButton(
                          onPressed: () {
                            if (currentUser.uid == user.uid) {
                              //edit profile
                              Navigator.push(context, EditProfileView.route());
                            } else {
                              ref.read(userProfileControllerProvider.notifier).followUser(
                                    user: user,
                                    context: context,
                                    currentUser: currentUser,
                                  );
                              //showSnackBar(context, 'successful! Things will be updated very soon');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(
                                color: Pallete.whiteColor,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                          ),
                          child: Text(
                            currentUser.uid == user.uid
                                ? AppTexts.editProfile
                                : currentUser.following.contains(user.uid)
                                    ? AppTexts.unfollow
                                    : AppTexts.follow,
                            style: const TextStyle(color: Pallete.whiteColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(8),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Text(
                                user.name,
                                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                            ),
                            if (user.isTwitterBlue)
                            const Icon(
                              Icons.verified,
                              color: Pallete.blueColor,
                            ),
                          ],
                        ),
                        Text(
                          '@${user.name}',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Pallete.greyColor),
                        ),
                        Text(
                          user.bio,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            FollowCount(count: user.following.length, text: AppTexts.following),
                            const SizedBox(
                              width: 15,
                            ),
                            FollowCount(count: user.followers.length, text: AppTexts.followers),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: ref.watch(getUserPostsProvider(user.uid)).when(
              data: (posts) {
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return PostCard(
                      post: post,
                      where: () {
                        Navigator.push(
                          context,
                          PostReplyScreen.route(post),
                        );
                      },
                    );
                  },
                );
              },
              error: (error, stackTrace) {
                return ErrorText(error: error.toString());
              },
              loading: () {
                return const Loader();
              },
            ),
          );
  }
}
