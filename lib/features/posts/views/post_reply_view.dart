import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kooginapp/core/common/loading_page.dart';
import 'package:kooginapp/core/constants/app_texts.dart';
import 'package:kooginapp/core/constants/constants.dart';
import 'package:kooginapp/core/error/error_page.dart';
import 'package:kooginapp/core/models/post_model.dart';
import 'package:kooginapp/features/auth/controller/auth_controller.dart';
import 'package:kooginapp/features/posts/controller/post_controller.dart';
import 'package:kooginapp/features/posts/widgets/post_card.dart';

class PostReplyScreen extends ConsumerWidget {
  static route(Post post) => MaterialPageRoute(
        builder: (context) => PostReplyScreen(post: post),
      );
  final Post post;
  const PostReplyScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thePoster = ref.watch(userDetailsProvider(post.uid)).value;
    final replyController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppTexts.post),
      ),
      body: Column(
        children: [
          PostCard(
            post: post,
            where: () {},
          ),
          ref.watch(getRepliesToPostProvider(post)).when(
                data: (posts) {
                  return ref.watch(getLatestPostProvider).when(
                        data: (data) {
                          final latestPost = Post.fromMap(data.payload);
                          bool isPostAlreadyPresent = false;
                          for (final postModel in posts) {
                            if (postModel.id == latestPost.id) {
                              isPostAlreadyPresent = true;
                              break;
                            }
                          }
                          if (!isPostAlreadyPresent && latestPost.repliedTo == post.id) {
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
                          }

                          return Expanded(
                            child: ListView.builder(
                              itemCount: posts.length,
                              itemBuilder: (context, index) {
                                final post = posts[index];
                                return PostCard(
                                  post: post,
                                  where: () {},
                                );
                              },
                            ),
                          );
                        },
                        error: (error, stackTrace) => ErrorText(error: error.toString()),
                        loading: () {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: posts.length,
                              itemBuilder: (context, index) {
                                final post = posts[index];
                                return PostCard(
                                  post: post,
                                  where: () {},
                                );
                              },
                            ),
                          );
                        },
                      );
                  /*
            
             */
                },
                error: (error, stackTrace) => ErrorText(error: error.toString()),
                loading: () => const Loader(),
              )
        ],
      ),
      bottomNavigationBar: Padding(
        padding:  MediaQuery.of(context).viewInsets,
        
        child: TextField(
          controller: replyController,
          onSubmitted: (value) {
            ref.read(postControllerProvider.notifier).sharePost(
              images: [],
              text: '@${thePoster?.name} $value',
              context: context,
              repliedTo: post.id,
              repliedToUserId: post.uid,
            );
            replyController.text = '';
          },
          decoration: const InputDecoration(
            hintText: AppTexts.writeYourReply,
            contentPadding: EdgeInsets.all(8),
          ),
        ),
      ),
    );
  }
}
