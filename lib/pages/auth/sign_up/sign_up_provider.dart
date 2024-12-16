import 'package:flareline/services/auth_service.dart';
import 'package:flareline_uikit/core/mvvm/base_viewmodel.dart';
import 'package:flareline_uikit/utils/snackbar_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SignUpProvider extends BaseViewModel {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController rePasswordController;
  late TextEditingController nameController;
  late TextEditingController phoneController;

  String? emailError;
  String? passwordError;
  String? rePasswordError;
  String? nameError;
  String? phoneError;

  SignUpProvider(super.context) {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    rePasswordController = TextEditingController();
    nameController = TextEditingController();
    phoneController = TextEditingController();
  }

  Future<void> signUp(BuildContext context) async {
    bool hasError = false;

    if (emailController.text.isEmpty) {
      emailError = 'Email is required';
      hasError = true;
    } else {
      emailError = null;
    }

    if (passwordController.text.isEmpty) {
      passwordError = 'Password is required';
      hasError = true;
    } else if (passwordController.text.trim().length < 6) {
      passwordError = 'Password must be at least 6 characters';
      hasError = true;
    } else {
      passwordError = null;
    }

    if (rePasswordController.text != passwordController.text) {
      rePasswordError = 'Passwords do not match';
      hasError = true;
    } else {
      rePasswordError = null;
    }

    if (nameController.text.isEmpty) {
      nameError = 'Name is required';
      hasError = true;
    } else {
      nameError = null;
    }

    if (phoneController.text.isEmpty) {
      phoneError = 'Phone number is required';
      hasError = true;
    } else {
      phoneError = null;
    }

    if (hasError) {
      notifyListeners();
      return;
    }

    try {
      final authService = AuthService();
      await authService.signUp(
        nameController.text,
        emailController.text,
        phoneController.text,
        passwordController.text,
      );
      Navigator.of(context).popAndPushNamed('/signIn');
    } catch (e) {
      print(e);
      SnackBarUtil.showSnack(context, e.toString());
    }
  }
}
