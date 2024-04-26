import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kooginapp/core/common/loading_page.dart';
import 'package:kooginapp/core/constants/app_texts.dart';
import 'package:kooginapp/core/providers/providers.dart';
import 'package:kooginapp/features/auth/controller/auth_controller.dart';
import 'package:kooginapp/features/auth/view/login_view.dart';
import 'package:kooginapp/features/auth/widgets/auth_field.dart';

import '../../../core/common/common.dart';
import '../../../core/constants/constants.dart';
import '../../../core/theme/theme.dart';

class SignUpView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const SignUpView(),
      );
  const SignUpView({super.key});

  @override
  ConsumerState<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  final appbar = UIConstants.appBar();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void onSignUp() {
    // ignore: unused_local_variable
    final res = ref
        .read(authControllerProvider.notifier)
        .signUp(email: emailController.text, password: passwordController.text, context: context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider); //! we are watching authControllerProvider
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
                            onTap: onSignUp,
                            label: AppTexts.done,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        RichText(
                          text: TextSpan(
                            text: AppTexts.alreadyAcc,
                            style: TextStyle(fontSize: 16, color: 
                            appThemeState.isDarkModeEnabled ? Pallete.whiteColor : Pallete.blackColor,
                            ),
                            children: [
                              TextSpan(
                                text: AppTexts.login,
                                style: const TextStyle(
                                  color: Pallete.blueColor,
                                  fontSize: 16,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushReplacement(
                                      context,
                                      LoginView.route(),
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
