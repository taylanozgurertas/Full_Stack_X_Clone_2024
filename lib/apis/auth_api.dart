import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:kooginapp/core/error/failure.dart';
import 'package:kooginapp/core/providers/providers.dart';
import 'package:kooginapp/core/type_defs.dart';

//! THIS IS BACKEND RELATED CODE, WE ARE USING FPDART PACKAGE

final authAPIProvider = Provider((ref) {
  final account = ref.watch(appwriteAccountProvider);
  return AuthAPI(account: account); //! it watches appwriteAccountProvider for any changes
}); //immutable single instance. it provides read-only value.

//appwrite/models.dart comes from appwrite package and it has model.User and its for create user and bunch of methods

abstract class IAuthAPI {
  FutureEither<model.User> signUp({required String email, required String password});
  FutureEither<model.Session> login({required String email, required String password});
  Future<model.User?> currentUserAccount();
  FutureEitherVoid logout();
}

class AuthAPI implements IAuthAPI {
  final Account _account;

  AuthAPI({required Account account}) : _account = account;

  @override
  Future<model.User?> currentUserAccount() async {
    try {
      return await _account.get();
    } on AppwriteException catch (_) {
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  FutureEither<model.User> signUp({required String email, required String password}) async {
    try {
      final account = await _account.create(userId: ID.unique(), email: email, password: password);
      return right(account);
    } on AppwriteException catch (e, stackTrace) {
      return left(Failure(e.message ?? 'Some unexpected error occurred', stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  FutureEither<model.Session> login({required String email, required String password}) async {
    try {
      final session = await _account.createEmailPasswordSession(email: email, password: password);
      return right(session);
    } on AppwriteException catch (e, stackTrace) {
      return left(Failure(e.message ?? 'Some unexpected error occurred', stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }
  
  @override
  FutureEitherVoid logout() async{
    try {
      await _account.deleteSession(sessionId: 'current');
      return right(null);
    } on AppwriteException catch (e, stackTrace) {
      return left(Failure(e.message ?? 'Some unexpected error occurred', stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }
}
