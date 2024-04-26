import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:kooginapp/core/models/post_model.dart';
import 'package:kooginapp/core/providers/providers.dart';
import 'package:kooginapp/core/type_defs.dart';

import '../core/constants/constants.dart';
import '../core/error/failure.dart';

final postAPIProvider = Provider((ref) {
  return PostAPI(
    db: ref.watch(appwriteDatabaseProvider),
    realtime: ref.watch(appWriteRealTimeProviderForPosts),
  );
});

abstract class IPostAPI {
  FutureEither<Document> sharePost(Post post);
  Future<List<Document>> getPosts();
  Stream<RealtimeMessage> getLatestPost();
  FutureEither<Document> likePost(Post post);
  FutureEither<Document> updateReshareCount(Post post);
  Future<List<Document>> getRepliesToPost(Post post);
  Future<Document> getPostById(String id);
  Future<List<Document>> getUserPosts(String uid);
  Future<List<Document>> getPostsByHashtag(String hashtag);
}

class PostAPI implements IPostAPI {
  final Databases _db;
  final Realtime _realtime;

  PostAPI({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;

  @override
  FutureEither<Document> sharePost(post) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.postCollection,
        documentId: ID.unique(),
        data: post.toMap(),
      );
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(Failure(
        e.message ?? 'Some unexpected error occurred',
        st,
      ));
    } catch (e, st) {
      return left(Failure(
        e.toString(),
        st,
      ));
    }
  }

  @override
  Future<List<Document>> getPosts() async {
    final documents = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.postCollection,
        queries: [
          Query.orderDesc('postedAt'), //postedAt e göre desc sekilde listelensin postlar cekildiginde querisi
        ]);
    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestPost() {
    return _realtime.subscribe(
        ['databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.postCollection}.documents']).stream;
  }

  @override
  FutureEither<Document> likePost(Post post) async {
    try {
      final document = await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.postCollection,
        documentId: post.id,
        data: {
          'likes': post.likes,
        },
      );
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(Failure(
        e.message ?? 'Some unexpected error occurred',
        st,
      ));
    } catch (e, st) {
      return left(Failure(
        e.toString(),
        st,
      ));
    }
  }

  @override //fix it but im not really using this
  FutureEither<Document> updateReshareCount(Post post) async {
    try {
      final document = await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.postCollection,
        documentId: post.id,
        data: {
          'reshareCount': post.reshareCount,
        },
      );
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(Failure(
        e.message ?? 'Some unexpected error occurred',
        st,
      ));
    } catch (e, st) {
      return left(Failure(
        e.toString(),
        st,
      ));
    }
  }

  @override
  Future<List<Document>> getRepliesToPost(Post post) async {
    final document = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.postCollection,
        queries: [
          Query.equal('repliedTo', post.id),
        ]);
    return document.documents;
  }

  @override
  Future<Document> getPostById(String id) async {
    return _db.getDocument(
        databaseId: AppwriteConstants.databaseId, collectionId: AppwriteConstants.usersCollection, documentId: id);
  }

  @override
  Future<List<Document>> getUserPosts(String uid) async {
    final documents = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.postCollection,
        queries: [
          Query.equal('uid', uid),
        ]);
    return documents.documents;
  }

  @override
  Future<List<Document>> getPostsByHashtag(String hashtag) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.postCollection,
      queries: [
        Query.contains('hashtags', hashtag),
      ],
    );
    return documents.documents;
  }
}
