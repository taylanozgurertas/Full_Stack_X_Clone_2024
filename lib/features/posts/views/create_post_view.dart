import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kooginapp/core/common/common.dart';
import 'package:kooginapp/core/common/loading_page.dart';
import 'package:kooginapp/core/constants/app_texts.dart';
import 'package:kooginapp/core/constants/asset_constants.dart';
import 'package:kooginapp/core/theme/theme.dart';
import 'package:kooginapp/core/utils/utils.dart';
import 'package:kooginapp/features/auth/controller/auth_controller.dart';
import 'package:kooginapp/features/posts/controller/post_controller.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const CreatePostScreen(),
      );
  const CreatePostScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final postTextController = TextEditingController();
  List<File> images = [];

  @override
  void dispose() {
    super.dispose();
    postTextController.dispose();
  }

  void sharePost() {
    ref.read(postControllerProvider.notifier).sharePost(
          images: images,
          text: postTextController.text,
          context: context,
          repliedTo: '',
          repliedToUserId: '', 
        );
    Navigator.pop(context);
  }

  void onPickImages() async {
    images = await pickImages();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    final isLoading = ref.watch(postControllerProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close, size: 30),
        ),
        actions: [
          RoundedSmallButton(
            onTap: sharePost,
            label: AppTexts.send,
          ),
        ],
      ),
      body: isLoading || currentUser == null
          ? const Loader()
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 15,
                        ),
                        CircleAvatar(
                          backgroundImage: NetworkImage(currentUser.profilePic == '' ? AssetsConstants.noProfilePicture : currentUser.profilePic),
                          radius: 35,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: TextField(
                              controller: postTextController,
                              style: const TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                  hintText: "${AppTexts.whatsHappening}${currentUser.name}?",
                                  hintStyle: const TextStyle(
                                    color: Pallete.greyColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  border: InputBorder.none),
                              maxLines: null,
                            ),
                          ),
                        )
                      ],
                    ),
                    if (images.isNotEmpty)
                      CarouselSlider(
                        items: images.map(
                          (file) {
                            return Container(
                              decoration: BoxDecoration(
                                  border: Border.all(width: 5, color: Pallete.whiteColor),
                                  borderRadius: BorderRadius.circular(10)),
                              width: 200,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              child: Image.file(
                                file,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ).toList(),
                        options: CarouselOptions(
                          height: 200,
                          enableInfiniteScroll: false,
                        ),
                      ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Container(
        padding: Paddings.bottomLinePadding,
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: Pallete.greyColor, width: 0.3))),
        child: Row(
          children: [
            Padding(
              padding: Paddings.paddingForBottomNavigationIcons,
              child: GestureDetector(onTap: onPickImages, child: const Icon(Icons.photo)),
            ),
            Padding(
              padding: Paddings.paddingForBottomNavigationIcons,
              child: const Icon(Icons.gif_box_rounded),
            ),
            Padding(
              padding: Paddings.paddingForBottomNavigationIcons,
              child: const Icon(Icons.emoji_emotions),
            ),
          ],
        ),
      ),
    );
  }
}
