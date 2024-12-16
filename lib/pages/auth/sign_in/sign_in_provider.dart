import 'package:flareline/services/auth_service.dart';
import 'package:flareline_uikit/core/mvvm/base_viewmodel.dart';
import 'package:flareline_uikit/utils/snackbar_util.dart';
import 'package:flutter/material.dart';

class SignInProvider extends BaseViewModel {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  SignInProvider(BuildContext ctx) : super(ctx) {
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  Future<void> signIn(BuildContext context) async {
    try {
      final authService = AuthService();
      final tokens = await authService.signIn(
        emailController.text,
        passwordController.text,
      );
      // Handle successful sign-in, e.g., save tokens, navigate to home page
      Navigator.of(context).pushNamed('/');
    } catch (e) {
      print(e);
      SnackBarUtil.showSnack(context, e.toString());
    }
  }
}
