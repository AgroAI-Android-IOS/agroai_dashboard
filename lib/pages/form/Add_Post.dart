import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddPost extends StatefulWidget {
  const AddPost({super.key});
  @override
  State<AddPost> createState() => _AddPostState();

  String breakTabTitle(BuildContext context) {
    return 'Add Post'; // Replace with localization if needed.
  }
}

class _AddPostState extends State<AddPost> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _userController = TextEditingController();
  String? selectedPlant;

  // Mocked plant options

  final String authToken =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3NDM2OGQyNDk0ZGYyZjQ4ZmQwMzBhMCIsIm5hbWUiOiJjYWhtZWQiLCJlbWFpbCI6ImFobWVkaGNoYWljaGk0MEBnbWFpbC5jb20iLCJpYXQiOjE3MzMxNDQ0ODMsImV4cCI6MTczMzIzMDg4M30.u2VnOFu3D1Wc0x-pmy0bh0BirTDkKv7ZL9yIqcaJWLQ'; // Replace with actual token

  Future<void> submitPost() async {
    if (_formKey.currentState!.validate()) {
      final post = {
        "title": _titleController.text,
        "content": _contentController.text,
        "user": _userController.text,
      };

      try {
        final response = await http.post(
          Uri.parse('http://192.168.1.121:3000/api/v1/post'),
          headers: {
            "Content-Type": "application/json",
            "Authorization":
                "Bearer $authToken", // Include the token in the headers
          },
          body: json.encode(post),
        );

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Post added successfully!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add post: ${response.body}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.breakTabTitle(context))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter content';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _userController,
                decoration: const InputDecoration(labelText: 'User ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a user ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: submitPost,
                child: const Text('Submit Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
