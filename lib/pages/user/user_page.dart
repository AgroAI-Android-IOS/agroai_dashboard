import 'package:flareline/pages/layout.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';
import 'user_provider.dart';

class UserPage extends LayoutWidget {
  UserPage({super.key});

  final TextStyle errorStyle = TextStyle(
    color: Colors.red,
    fontSize: 12.0,
  );

  @override
  String breakTabTitle(BuildContext context) {
    return 'User Management';
  }

  @override
  Widget contentDesktopWidget(BuildContext context) {
    return bodyWidget(context, viewModelBuilder(context), null);
  }

  @override
  Widget bodyWidget(
      BuildContext context, UserProvider viewModel, Widget? child) {
    return Stack(
      children: [
        viewModel.users.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person, size: 80, color: Colors.blueGrey),
                    SizedBox(height: 16),
                    Text(
                      "No Users Available",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Add new users to see them here.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width,
                  ),
                  child: DataTable(
                    columnSpacing: 20,
                    horizontalMargin: 16,
                    headingRowColor: MaterialStateColor.resolveWith(
                        (states) => Colors.grey[200]!),
                    headingTextStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blueGrey),
                    columns: [
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Role')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: viewModel.users.map((user) {
                      return DataRow(cells: [
                        DataCell(
                          Text(
                            user.name,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        DataCell(
                          Text(
                            user.email,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        DataCell(
                          Text(
                            user.role!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  _showUpdateDialog(context, viewModel, user);
                                },
                                tooltip: 'Edit User',
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _showDeleteConfirmationDialog(
                                      context, viewModel, user);
                                },
                                tooltip: 'Delete User',
                              ),
                            ],
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: () {
              _showAddUserDialog(context, viewModel);
            },
            child: Icon(Icons.add),
            tooltip: 'Add User',
          ),
        ),
      ],
    );
  }

  @override
  UserProvider viewModelBuilder(BuildContext context) {
    return UserProvider(context);
  }

  void _showUpdateDialog(
      BuildContext context, UserProvider viewModel, User user) async {
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);
    final passwordController = TextEditingController(text: user.password);
    String? nameError;
    String? emailError;
    String? passwordError;

    final updatedUser = await showDialog<User?>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Update User",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Name",
                      errorText: nameError,
                      errorStyle: errorStyle,
                    ),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      errorText: emailError,
                      errorStyle: errorStyle,
                    ),
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: "Password",
                      errorText: passwordError,
                      errorStyle: errorStyle,
                    ),
                    obscureText: true,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text("Save"),
                  onPressed: () {
                    setState(() {
                      nameError = nameController.text.isEmpty
                          ? "Name is required"
                          : null;
                      emailError = emailController.text.isEmpty
                          ? "Email is required"
                          : null;
                      passwordError = passwordController.text.isEmpty
                          ? "Password is required"
                          : null;
                    });

                    if (nameError == null &&
                        emailError == null &&
                        passwordError == null) {
                      final updatedUser = User(
                        id: user.id,
                        name: nameController.text,
                        email: emailController.text,
                        password: passwordController.text,
                        role: user.role,
                      );
                      Navigator.pop(context, updatedUser);
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );

    if (updatedUser != null) {
      viewModel.updateUser(context, updatedUser);
    }
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, UserProvider viewModel, User user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete User",
              style: TextStyle(fontWeight: FontWeight.bold)),
          content:
              Text("Are you sure you want to delete the user '${user.name}'?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("Delete"),
              onPressed: () {
                Navigator.pop(context);
                viewModel.deleteUser(context, user);
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddUserDialog(BuildContext context, UserProvider viewModel) async {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final passwordController = TextEditingController();
    final roleController = TextEditingController();
    String? nameError;
    String? emailError;
    String? passwordError;
    String? roleError;

    final newUser = await showDialog<User?>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Add User",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Name",
                      errorText: nameError,
                      errorStyle: errorStyle,
                    ),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      errorText: emailError,
                      errorStyle: errorStyle,
                    ),
                  ),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(labelText: "Phone"),
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: "Password",
                      errorText: passwordError,
                      errorStyle: errorStyle,
                    ),
                    obscureText: true,
                  ),
                  TextField(
                    controller: roleController,
                    decoration: InputDecoration(
                      labelText: "Role",
                      errorText: roleError,
                      errorStyle: errorStyle,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text("Save"),
                  onPressed: () {
                    setState(() {
                      nameError = nameController.text.isEmpty
                          ? "Name is required"
                          : null;
                      emailError = emailController.text.isEmpty
                          ? "Email is required"
                          : null;
                      passwordError = passwordController.text.isEmpty
                          ? "Password is required"
                          : null;
                      roleError = roleController.text.isEmpty
                          ? "Role is required"
                          : null;
                    });

                    if (nameError == null &&
                        emailError == null &&
                        passwordError == null &&
                        roleError == null) {
                      final newUser = User(
                        id: '', // Assuming the ID will be generated by the backend
                        name: nameController.text,
                        email: emailController.text,
                        phone: phoneController.text,
                        password: passwordController.text,
                        role: roleController.text,
                      );
                      Navigator.pop(context, newUser);
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );

    if (newUser != null) {
      viewModel.addUser(context, newUser);
    }
  }
}
