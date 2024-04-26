import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kooginapp/core/common/loading_page.dart';
import 'package:kooginapp/core/constants/app_texts.dart';

import 'package:kooginapp/core/enums/post_type_enum.dart';
import 'package:kooginapp/core/error/error_page.dart';
import 'package:kooginapp/core/models/post_model.dart';
import 'package:kooginapp/core/providers/providers.dart';
import 'package:kooginapp/core/theme/theme.dart';
import 'package:kooginapp/features/posts/controller/post_controller.dart';
import 'package:kooginapp/features/posts/views/post_reply_view.dart';
import 'package:kooginapp/features/posts/widgets/carousel_image.dart';
import 'package:kooginapp/features/posts/widgets/hashtag_text.dart';
import 'package:kooginapp/features/posts/widgets/post_icon_buttons.dart';
import 'package:kooginapp/features/user_profile/view/user_profile_view.dart';
import 'package:like_button/like_button.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:kooginapp/features/auth/controller/auth_controller.dart';

import '../../../core/constants/constants.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  final VoidCallback where;
  const PostCard({required this.post, super.key, required this.where});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    final appThemeState = ref.watch(appThemeStateNotifier);
    return currentUser == null
        ? const SizedBox.shrink()
        : ref.watch(userDetailsProvider(post.uid)).when(
              data: (user) {
                return GestureDetector(
                  onTap: where,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context, UserProfileView.route(user));
                              },
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    user.profilePic == '' ? AssetsConstants.noProfilePicture : user.profilePic),
                                radius: 25,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (post.retweetedBy.isNotEmpty)
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.subdirectory_arrow_left_outlined,
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        '${post.retweetedBy} ${AppTexts.reshared}',
                                        style: const TextStyle(
                                            color: Pallete.greyColor, fontSize: 17, fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: user.isTwitterBlue ? 2 : 5),
                                      child: Text(
                                        user.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    if (user.isTwitterBlue)
                                      const Icon(
                                        Icons.verified,
                                        color: Pallete.blueColor,
                                      ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      '@${user.name} . ${timeago.format(post.postedAt, locale: 'en_short')}',
                                      style: const TextStyle(
                                        fontSize: 17,
                                        color: Pallete.greyColor,
                                      ),
                                    ),
                                  ],
                                ),
                                appThemeState.isDarkModeEnabled ? HashtagText(text: post.text, textColor: Pallete.whiteColor) : HashtagText(text: post.text, textColor: Pallete.blackColor,),
                                
                                if (post.postType == PostType.image) CarouselImage(imageLinks: post.imageLinks),
                                if (post.link.isNotEmpty) ...[
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  AnyLinkPreview(
                                      displayDirection: UIDirection.uiDirectionHorizontal, link: 'https://${post.link}')
                                ],
                                Container(
                                  margin: const EdgeInsets.only(
                                    top: 10,
                                    right: 20,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      PostIconButton(
                                        theIcon: Icons.mode_comment_outlined,
                                        text: '',
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            PostReplyScreen.route(post),
                                          );
                                        },
                                      ),
                                      LikeButton(
                                        isLiked: post.likes.contains(currentUser.uid),
                                        onTap: (isLiked) async {
                                          ref.read(postControllerProvider.notifier).likePost(post, currentUser);
                                          return !isLiked;
                                        },
                                        size: 25,
                                        likeCount: post.likes.length.toInt(),
                                        countBuilder: (likeCount, isLiked, text) {
                                          return Padding(
                                            padding: const EdgeInsets.only(left: 2),
                                            child: Text(
                                              text,
                                              style: TextStyle(
                                                color: isLiked ? Pallete.redColor : Pallete.whiteColor,
                                                fontSize: 16,
                                              ),
                                            ),
                                          );
                                        },
                                        likeBuilder: (isLiked) {
                                          return isLiked
                                              ? const Icon(Icons.favorite, color: Pallete.redColor)
                                              : const Icon(
                                                  Icons.favorite_border_outlined,
                                                  color: Pallete.greyColor,
                                                );
                                        },
                                      ),

                                      //reshare feature (i didnt like it so ill keep it like this but its working)

                                      PostIconButton(
                                        theIcon: Icons.subdirectory_arrow_left_outlined,
                                        text: '',
                                        onTap: () {
                                          ref
                                              .read(postControllerProvider.notifier)
                                              .resharePost(post, currentUser, context);
                                        },
                                      ),

                                      /*
                                      //view feature i didnt like it and its logic is not well written so ill keep it like this
                                      PostIconButton(
                                        theIcon: Icons.align_vertical_bottom_rounded,
                                        text: (post.commentIds.length + post.reshareCount + post.likes.length).toString(),
                                        onTap: () {},
                                      ),
                                       */
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 1,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const Divider(
                        color: Pallete.greyColor,
                        thickness: 0.1,
                      ),
                    ],
                  ),
                );
              },
              error: (error, stackTrace) => ErrorText(
                error: error.toString(),
              ),
              loading: () => const Loader(),
            );
  }
}
