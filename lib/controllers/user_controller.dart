import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agroai_dashboard/services/user_service.dart';

class UserController extends GetxController {
  final UserService userService;
  var users = <User>[].obs;
  var isLoading = false.obs;

  UserController(this.userService);

  @override
  void onInit() {
    fetchUsers();
    super.onInit();
  }

  void fetchUsers() async {
    try {
      isLoading(true);
      var fetchedUsers = await userService.getUsers();
      if (fetchedUsers != null) {
        users.assignAll(fetchedUsers);
      }
    } finally {
      isLoading(false);
    }
  }

  void createUser(User user) async {
    try {
      isLoading(true);
      var createdUser = await userService.createUser(user);
      if (createdUser != null) {
        users.add(createdUser);
      }
    } finally {
      isLoading(false);
    }
  }

  void updateUser(int id, User user) async {
    try {
      isLoading(true);
      var updatedUser = await userService.updateUser(id, user);
      if (updatedUser != null) {
        var index = users.indexWhere((u) => u.id == id);
        if (index != -1) {
          users[index] = updatedUser;
        }
      }
    } finally {
      isLoading(false);
    }
  }

  void deleteUser(int id) async {
    try {
      isLoading(true);
      await userService.deleteUser(id);
      users.removeWhere((u) => u.id == id);
    } finally {
      isLoading(false);
    }
  }
}
