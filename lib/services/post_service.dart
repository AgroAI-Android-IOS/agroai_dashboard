import 'dart:convert';

import 'package:flareline/core/constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/post.dart';

class PostService {
  static const String baseUrl = '${Constant.baseUrl}/post';

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  Future<List<Post>> fetchPosts() async {
    try {
      final token = await _getToken();
      print('Sending GET request to $baseUrl');
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Request Headers: ${response.request?.headers}');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((post) => Post.fromJson(post)).toList();
      } else {
        print('Unexpected response: ${response.body}');
        throw Exception(
          'Failed to load posts. Status: ${response.statusCode}, Body: ${response.body}',
        );
      }
    } catch (e) {
      print('Error fetching posts: $e');
      throw Exception('Failed to load posts: $e');
    }
  }

  Future<void> deletePost(String postId) async {
    final token = await _getToken();
    final url = '$baseUrl/$postId';
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Post deleted successfully');
      } else {
        print(
            'Failed to delete post. Status: ${response.statusCode}, Body: ${response.body}');
        throw Exception('Failed to delete post');
      }
    } catch (e) {
      print('Error deleting post: $e');
      throw Exception('Failed to delete post: $e');
    }
  }

  Future<void> updatePost(Post post) async {
    final token = await _getToken();
    final response = await http.patch(
      Uri.parse('$baseUrl/${post.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'content': post.content,
      }),
    );

    if (response.statusCode == 200) {
      print('Post updated successfully');
    } else {
      print(
          'Failed to update post. Status: ${response.statusCode}, Body: ${response.body}');
      throw Exception('Failed to update the post');
    }
  }
}
