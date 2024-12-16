import 'package:flareline/services/user_service.dart';
import 'package:flareline_uikit/core/mvvm/base_viewmodel.dart';
import 'package:flareline_uikit/utils/snackbar_util.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';

class UserProvider extends BaseViewModel {
  late Future<List<User>> futureUsers;
  List<User> users = [];

  UserProvider(BuildContext ctx) : super(ctx) {
    _loadUsers(ctx);
  }

  void _loadUsers(BuildContext context) async {
    try {
      final fetchedUsers = await UserService().getUsers();
      users = fetchedUsers;
      notifyListeners();
    } catch (error) {
      print(error);
      SnackBarUtil.showSnack(context, "Error loading users: $error");
    }
  }

  Future<void> deleteUser(BuildContext context, User user) async {
    try {
      await UserService().deleteUser(user.id!);
      users.remove(user);
      notifyListeners();
      SnackBarUtil.showSnack(
          context, "User '${user.name}' deleted successfully");
    } catch (error) {
      SnackBarUtil.showSnack(context, "Error deleting user: $error");
    }
  }

  Future<void> updateUser(BuildContext context, User user) async {
    if (user.name.isEmpty ||
        user.email.isEmpty ||
        user.password.isEmpty ||
        user.role!.isEmpty) {
      SnackBarUtil.showSnack(context, "All fields are required.");
      return;
    }
    try {
      final updatedUser = await UserService().updateUser(user.id!, user);
      final index = users.indexWhere((u) => u.id == user.id);
      users[index] = updatedUser;
      notifyListeners();
      SnackBarUtil.showSnack(
          context, "User '${updatedUser.name}' updated successfully");
    } catch (error) {
      SnackBarUtil.showSnack(context, "Error updating user: $error");
    }
  }

  Future<void> addUser(BuildContext context, User user) async {
    if (user.name.isEmpty ||
        user.email.isEmpty ||
        user.password.isEmpty ||
        user.role!.isEmpty) {
      SnackBarUtil.showSnack(context, "All fields are required.");
      return;
    }
    try {
      final newUser = await UserService().createUser(User(
          name: user.name,
          email: user.email,
          password: user.password,
          id: '',
          role: 'User'));
      users.add(newUser);
      notifyListeners();
      SnackBarUtil.showSnack(
          context, "User '${newUser.name}' added successfully");
    } catch (error) {
      SnackBarUtil.showSnack(context, "Error adding user: $error");
    }
  }
}
