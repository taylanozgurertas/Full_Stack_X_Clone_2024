import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kooginapp/core/common/loading_page.dart';
import 'package:kooginapp/core/constants/app_texts.dart';
import 'package:kooginapp/core/error/error_page.dart';
import 'package:kooginapp/features/posts/controller/post_controller.dart';
import 'package:kooginapp/features/posts/views/post_reply_view.dart';
import 'package:kooginapp/features/posts/widgets/post_card.dart';

class HashtagView extends ConsumerWidget {
  static route(String hashtag) => MaterialPageRoute(
        builder: (context) => HashtagView(hashtag: hashtag),
      );

  final String hashtag;
  const HashtagView({
    super.key,
    required this.hashtag,
  });


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(AppTexts.hashtagTitle),
        ),
        body: ref.watch(getPostsByHashtagProvider(hashtag)).when(
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

                /*
            
             */
              },
              error: (error, stackTrace) => ErrorText(error: error.toString()),
              loading: () => const Loader(),
            ));
  }
}
