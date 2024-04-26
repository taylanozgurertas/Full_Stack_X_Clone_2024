import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kooginapp/core/common/loading_page.dart';
import 'package:kooginapp/core/common/rounded_small_button.dart';
import 'package:kooginapp/core/constants/app_texts.dart';
import 'package:kooginapp/core/providers/providers.dart';
import 'package:kooginapp/core/theme/pallete.dart';
import 'package:kooginapp/features/auth/controller/auth_controller.dart';
import 'package:kooginapp/features/auth/view/signup_view.dart';
import 'package:kooginapp/features/auth/widgets/auth_field.dart';

import '../../../core/constants/constants.dart';

class LoginView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const LoginView(),
      );
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final appbar =
      UIConstants.appBar(); //! OPTIMIZATION.FOR OTHERWISE EVERY TIME BUILD FUNC. IS CALLED APPBAR WILL BE CREATED AGAIN

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void onLogin() {
    // ignore: unused_local_variable
    final res = ref
        .read(authControllerProvider.notifier)
        .login(email: emailController.text, password: passwordController.text, context: context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    final appThemeState = ref.watch(appThemeStateNotifier);
    return Scaffold(
        appBar: appbar,
        body: isLoading
            ? const Loader()
            : Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        AuthField(
                          controller: emailController,
                          hintText: AppTexts.email,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        AuthField(
                          controller: passwordController,
                          hintText: AppTexts.password,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: RoundedSmallButton(
                            onTap: onLogin,
                            label: AppTexts.done,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        RichText(
                          text: TextSpan(
                            text: AppTexts.dontHaveAc,
                            style: TextStyle(fontSize: 16, 
                            
                            color: appThemeState.isDarkModeEnabled ? Pallete.whiteColor : Pallete.blackColor,
                            ),
                            children: [
                              TextSpan(
                                text: AppTexts.signUp,
                                style: const TextStyle(
                                  color: Pallete.blueColor,
                                  fontSize: 16,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushReplacement(
                                      context,
                                      SignUpView.route(),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
  }
}
