// ignore_for_file: use_build_context_synchronously

import 'package:appwrite/models.dart' as model;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kooginapp/apis/auth_api.dart';
import 'package:kooginapp/apis/user_api.dart';
import 'package:kooginapp/core/constants/app_texts.dart';
import 'package:kooginapp/core/utils/utils.dart';
import 'package:kooginapp/features/auth/view/login_view.dart';
import 'package:kooginapp/features/auth/view/signup_view.dart';
import 'package:kooginapp/features/home/view/home_view.dart';
import 'package:kooginapp/core/models/user_model.dart';

//! thıs ıs statenotifierprovider
final authControllerProvider = StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(authAPI: ref.watch(authAPIProvider), userAPI: ref.watch(userAPIProvider));
});

final currentUserAccountProvider = FutureProvider((ref) async {
  final authController = ref.watch(authControllerProvider.notifier);
  return await authController.currentUser();
});

final currentUserDetailsProvider = FutureProvider.autoDispose((ref) async {
  final authController = ref.watch(authControllerProvider.notifier);
  final current = await authController.currentUser();
  if (current == null) {
  } else {
    final currentUserId = current.$id;
    final userDetails = ref.watch(userDetailsProvider(currentUserId));
    return userDetails.value;
  }
});

final userDetailsProvider = FutureProvider.family((ref, String? uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid!);
});

//! STATENOTIFIER is for the value which can be updated and which can also be read.

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserAPI _userAPI;

  //! it will manage the bool value
  AuthController({required AuthAPI authAPI, required UserAPI userAPI})
      : _authAPI = authAPI,
        _userAPI = userAPI,
        super(false); //! default value is FALSE

  Future<model.User?> currentUser() => _authAPI.currentUserAccount();

  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.signUp(email: email, password: password);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (user) async {
      UserModel userModel = UserModel(
        email: email,
        name: getNameFromEmail(email),
        followers: const [],
        following: const [],
        profilePic: '',
        bannerPic: '',
        uid: user.$id,
        bio: '',
        isTwitterBlue: false,
      );

      final res2 = await _userAPI.saveUserData(userModel);
      res2.fold((l) => showSnackBar(context, l.message), (r) {
        showSnackBar(context, AppTexts.accCreated);
        Navigator.pushReplacement(
          context,
          LoginView.route(),
        );
      });
    });
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.login(email: email, password: password);
    state = false;
    showSnackBar(context, AppTexts.tryingLogin);
    await Future.delayed(const Duration(seconds: 2));
    res.fold((l) => showSnackBar(context, l.message), (r) {
      Navigator.pushReplacement(context, HomeView.route());
    });
  }

  Future<UserModel> getUserData(String uid) async {
    final document = await _userAPI.getUserData(uid);
    final updatedUser = UserModel.fromMap(document.data);
    return updatedUser;
  }

  void logout(BuildContext context) async {
    final res = await _authAPI.logout();
    res.fold((l) => null, (r) {
      Navigator.pushAndRemoveUntil(context, SignUpView.route(), (route) => false);
    });
  }
}
