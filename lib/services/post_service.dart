/*import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart'; // Import the Post model

class PostService {
  static const String baseUrl = 'http://192.168.1.197:3000/api/v1/post';

  Future<List<Post>> fetchPosts() async {
    try {
      print('Sending GET request to $baseUrl');
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3NGM1OGMzOTJjMDkxZWNjNzliMDM2MCIsIm5hbWUiOiJhaG1lZCIsImVtYWlsIjoiYWhtZWRoY2hhaWNoaTQwQGdtYWlsLmNvbSIsImlhdCI6MTczMzA1NzIxMCwiZXhwIjoxNzMzMTQzNjEwfQ._Hn69z05-cKNvDtL-j3Xg5_YOgzqPflmRjepxAD0QZQ',
        },
      );

      // Debugging: Log request details
      print('Request Headers: ${response.request?.headers}');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Decode the response body
        List<dynamic> data = json.decode(response.body);

        // Map the JSON data to a list of Post objects
        return data.map((post) => Post.fromJson(post)).toList();
      } else {
        // Handle non-200 status codes
        print('Unexpected response: ${response.body}');
        throw Exception(
          'Failed to load posts. Status: ${response.statusCode}, Body: ${response.body}',
        );
      }
    } catch (e) {
      // Debugging: Log the caught error
      print('Error fetching posts: $e');
      throw Exception('Failed to load posts: $e');
    }
  }

  deletePost(id) {}

 Future<void> deletePost(String postId) async {
    // Example of deleting a post via an API
    final response = await http.delete(Uri.parse('https://api.example.com/posts/$postId'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete the post');
    }
  }

}*/

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../pages/models/post.dart';

class PostService {
  static const String baseUrl = 'http://localhost:3000/api/v1/post';
  Future<List<Post>> fetchPosts() async {
    try {
      print('Sending GET request to $baseUrl');
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3NDM2OGQyNDk0ZGYyZjQ4ZmQwMzBhMCIsIm5hbWUiOiJjYWhtZWQiLCJlbWFpbCI6ImFobWVkaGNoYWljaGk0MEBnbWFpbC5jb20iLCJpYXQiOjE3MzMxNDQ0ODMsImV4cCI6MTczMzIzMDg4M30.u2VnOFu3D1Wc0x-pmy0bh0BirTDkKv7ZL9yIqcaJWLQ',
        },
      );

      // Debugging: Log request details
      print('Request Headers: ${response.request?.headers}');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Decode the response body
        List<dynamic> data = json.decode(response.body);

        // Map the JSON data to a list of Post objects
        return data.map((post) => Post.fromJson(post)).toList();
      } else {
        // Handle non-200 status codes
        print('Unexpected response: ${response.body}');
        throw Exception(
          'Failed to load posts. Status: ${response.statusCode}, Body: ${response.body}',
        );
      }
    } catch (e) {
      // Debugging: Log the caught error
      print('Error fetching posts: $e');
      throw Exception('Failed to load posts: $e');
    }
  }

  /// Deletes a post with the given ID from the server
  Future<void> deletePost(String postId) async {
    final url =
        'http://localhost:3000/api/v1/post/$postId'; // Replace with your backend endpoint
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3NDM2OGQyNDk0ZGYyZjQ4ZmQwMzBhMCIsIm5hbWUiOiJjYWhtZWQiLCJlbWFpbCI6ImFobWVkaGNoYWljaGk0MEBnbWFpbC5jb20iLCJpYXQiOjE3MzMxNDQ0ODMsImV4cCI6MTczMzIzMDg4M30.u2VnOFu3D1Wc0x-pmy0bh0BirTDkKv7ZL9yIqcaJWLQ', // Use a valid token
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
    final response = await http.patch(
      Uri.parse('$baseUrl/${post.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3NDM2OGQyNDk0ZGYyZjQ4ZmQwMzBhMCIsIm5hbWUiOiJjYWhtZWQiLCJlbWFpbCI6ImFobWVkaGNoYWljaGk0MEBnbWFpbC5jb20iLCJpYXQiOjE3MzMxNDQ0ODMsImV4cCI6MTczMzIzMDg4M30.u2VnOFu3D1Wc0x-pmy0bh0BirTDkKv7ZL9yIqcaJWLQ', // Use a valid token
      },
      body: json.encode({
        'title': post.title,
        'content': post.content,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update the post');
    }
  }
}
