import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kooginapp/apis/post_api.dart';
import 'package:kooginapp/apis/storage_api.dart';
import 'package:kooginapp/core/constants/app_texts.dart';
import 'package:kooginapp/core/enums/notification_type_enum.dart';
import 'package:kooginapp/core/enums/post_type_enum.dart';
import 'package:kooginapp/core/models/post_model.dart';
import 'package:kooginapp/core/models/user_model.dart';
import 'package:kooginapp/core/utils/utils.dart';
import 'package:kooginapp/features/auth/controller/auth_controller.dart';
import 'package:kooginapp/features/notifications/controller/notification_controller.dart';

final postControllerProvider = StateNotifierProvider<PostController, bool>((ref) {
  return PostController(
    ref: ref,
    postAPI: ref.watch(postAPIProvider),
    storageAPI: ref.watch(storageAPIProvider),
    notificationController: ref.watch(notificationControllerProvider.notifier),
  );
});

final getPostsProvider = FutureProvider.autoDispose((ref) async {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getPosts();
});

final getLatestPostProvider = StreamProvider((ref) {
  final postAPI = ref.watch(postAPIProvider);
  return postAPI.getLatestPost();
});

final getRepliesToPostProvider = FutureProvider.family((ref, Post post) async {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getRepliesToPost(post);
});

final getPostByIdProvider = FutureProvider.family((ref, String id) async {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getPostById(id);
});

final getPostsByHashtagProvider = FutureProvider.family((ref, String hashtag) async {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getPostsByHashtag(hashtag);
});

class PostController extends StateNotifier<bool> {
  final PostAPI _postAPI;
  final StorageAPI _storageAPI;
  final Ref _ref;
  final NotificationController _notificationController;

  PostController({
    required Ref ref,
    required PostAPI postAPI,
    required StorageAPI storageAPI,
    required NotificationController notificationController,
  })  : _ref = ref,
        _postAPI = postAPI,
        _storageAPI = storageAPI,
        _notificationController = notificationController,
        super(false);

  Future<List<Post>> getPosts() async {
    final postList = await _postAPI.getPosts();
    return postList.map((post) => Post.fromMap(post.data)).toList();
  }

  Future<Post> getPostById(String id) async {
    final post = await _postAPI.getPostById(id);
    return Post.fromMap(post.data);
  }

  void sharePost({
    required List<File> images,
    required String text,
    required BuildContext context,
    required String repliedTo,
    required String repliedToUserId,
  }) {
    if (text.isEmpty) {
      showSnackBar(context, AppTexts.plsEnter);
      return;
    }

    if (images.isNotEmpty) {
      _shareImagePost(
          images: images, text: text, context: context, repliedTo: repliedTo, repliedToUserId: repliedToUserId);
    } else {
      _shareTextPost(text: text, context: context, repliedTo: repliedTo, repliedToUserId: repliedToUserId);
    }
  }

  void _shareImagePost({
    required List<File> images,
    required String text,
    required BuildContext context,
    required String repliedTo,
    required String repliedToUserId,
  }) async {
    state = true;
    final hashtags = _getHashtagsFromText(text);
    String link = _getLinkFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value!;
    final imageLinks = await _storageAPI.uploadImage(images);
    Post post = Post(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: imageLinks,
      uid: user.uid,
      postType: PostType.image,
      postedAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      id: '',
      reshareCount: 0,
      retweetedBy: '',
      repliedTo: repliedTo,
    );
    final res = await _postAPI.sharePost(post);

    res.fold((l) => showSnackBar(context, l.message), (r) {
      if (repliedToUserId.isNotEmpty) {
        _notificationController.createNotification(
          text: '${user.name} ${AppTexts.repliedYourPost}',
          postId: r.$id,
          notificationType: NotificationType.reply,
          uid: repliedToUserId,
        );
      }
    });
    state = false;
  }

  void _shareTextPost({
    required String text,
    required BuildContext context,
    required String repliedTo,
    required String repliedToUserId,
  }) async {
    state = true;
    final hashtags = _getHashtagsFromText(text);
    String link = _getLinkFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value!;
    Post post = Post(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: const [],
      uid: user.uid,
      postType: PostType.text,
      postedAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      id: '',
      reshareCount: 0,
      retweetedBy: '',
      repliedTo: repliedTo,
    );
    final res = await _postAPI.sharePost(post);
    res.fold((l) => showSnackBar(context, l.message), (r) {
      if (repliedToUserId.isNotEmpty) {
        _notificationController.createNotification(
          text: '${user.name} ${AppTexts.repliedYourPost}',
          postId: r.$id,
          notificationType: NotificationType.reply,
          uid: repliedToUserId,
        );
      }
    });
    state = false;
  }

  String _getLinkFromText(String text) {
    String link = '';
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith('https://') || word.startsWith('www.')) {
        link = word;
      }
    }
    return link;
  }

  List<String> _getHashtagsFromText(String text) {
    List<String> hashtags = [];
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith('#')) {
        hashtags.add(word);
      }
    }
    return hashtags;
  }

  void likePost(Post post, UserModel user) async {
    List<String> likes = post.likes;
    if (post.likes.contains(user.uid)) {
      likes.remove(user.uid);
    } else {
      likes.add(user.uid);
    }

    post = post.copyWith(likes: likes); //now it has updated
    final res = await _postAPI.likePost(post);
    res.fold((l) => null, (r) {
      _notificationController.createNotification(
        text: '${user.name} ${AppTexts.likedYourPost}',
        postId: post.id,
        notificationType: NotificationType.like,
        uid: post.uid,
      );
    });
  }

  void resharePost(Post post, UserModel currentUser, BuildContext context) async {
    post = post.copyWith(
      retweetedBy: currentUser.name,
      likes: [],
      commentIds: [],
      reshareCount: post.reshareCount + 1,
      postedAt: DateTime.now(),
    ); //now it has updated

    final res = await _postAPI.updateReshareCount(post);
    res.fold((l) => showSnackBar(context, l.message), (r) async {
      post = post.copyWith(
        id: ID.unique(),
        reshareCount: 0,
      );
      final res2 = await _postAPI.sharePost(post);
      res2.fold((l) => showSnackBar(context, l.message), (r) {
        _notificationController.createNotification(
          text: '${currentUser.name} ${AppTexts.resharedYourPost}',
          postId: post.id,
          notificationType: NotificationType.repost,
          uid: post.uid,
        );
        showSnackBar(context, AppTexts.reshareded);
      });
    });
  }

  Future<List<Post>> getRepliesToPost(Post post) async {
    final documents = await _postAPI.getRepliesToPost(post);
    return documents.map((post) => Post.fromMap(post.data)).toList();
  }

  Future<List<Post>> getPostsByHashtag(String hashtag) async {
    final documents = await _postAPI.getPostsByHashtag(hashtag);
    return documents.map((post) => Post.fromMap(post.data)).toList();
  }
}
