import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kooginapp/core/common/loading_page.dart';
import 'package:kooginapp/core/constants/constants.dart';
import 'package:kooginapp/core/error/error_page.dart';
import 'package:kooginapp/core/models/post_model.dart';
import 'package:kooginapp/features/posts/controller/post_controller.dart';
import 'package:kooginapp/features/posts/views/post_reply_view.dart';
import 'package:kooginapp/features/posts/widgets/post_card.dart';

class PostList extends ConsumerWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getPostsProvider).when(
          data: (posts) {
            return ref.watch(getLatestPostProvider).when(
                  data: (data) {
                    if (data.events.contains(
                      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.postCollection}.documents.*.create',
                    )) {
                      posts.insert(0, Post.fromMap(data.payload));
                    } else if (data.events.contains(
                      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.postCollection}.documents.*.update',
                    )) {
                      //we are listening any update from appwrite, and this logic is for reshare thing
                      //getting id of original post
                      final startingPoint = data.events[0].lastIndexOf('documents.');
                      final endingPoint = data.events[0].lastIndexOf('.update');
                      final postId = data.events[0].substring(startingPoint + 10, endingPoint);
                      var post = posts.where((element) => element.id == postId).first;
                      final postIndex = posts.indexOf(post);
                      posts.removeWhere((element) => element.id == postId);
                      post = Post.fromMap(data.payload);
                      posts.insert(postIndex, post);
                    }
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
                  error: (error, stackTrace) => ErrorText(error: error.toString()),
                  loading: () {
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
                );
            /*
            
             */
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
