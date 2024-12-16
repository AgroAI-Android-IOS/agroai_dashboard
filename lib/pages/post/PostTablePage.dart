import 'package:flutter/material.dart';

import '../../models/post.dart'; // Import your Post model
import '../../services/post_service.dart';

class PostTablePage extends StatefulWidget {
  const PostTablePage({super.key});

  @override
  _PostTablePageState createState() => _PostTablePageState();
}

class _PostTablePageState extends State<PostTablePage> {
  late Future<List<Post>> futurePosts;
  List<Post> posts = []; // Local list to manage the posts

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  void _loadPosts() async {
    try {
      final fetchedPosts = await PostService().fetchPosts();
      setState(() {
        posts = fetchedPosts;
      });
    } catch (error) {
      debugPrint("Error loading posts: $error");
    }
  }

  void _deletePost(Post post) async {
    try {
      await PostService().deletePost(post.id); // Call service to delete
      setState(() {
        posts.remove(post); // Remove post from the list
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Post '${post.content}' deleted successfully")),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting post: $error")),
      );
    }
  }

  void _updatePost(Post post) async {
    try {
      final updatedPost = await _showUpdateDialog(post);
      if (updatedPost != null) {
        await PostService().updatePost(updatedPost); // Call service to update

        // Replace the post in the list and refresh the UI
        setState(() {
          final index = posts.indexWhere((p) => p.id == post.id);
          posts[index] = updatedPost;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text("Post '${updatedPost.content}' updated successfully")),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating post: $error")),
      );
    }
  }

  Future<Post?> _showUpdateDialog(Post post) async {
    final contentController = TextEditingController(text: post.content);

    return showDialog<Post?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Update Post",
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: TextField(
            controller: contentController,
            decoration: InputDecoration(labelText: "Content"),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context); // Close dialog without saving
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: Text("Save"),
              onPressed: () {
                final updatedPost = Post(
                  id: post.id,
                  content: contentController.text,
                  user: post.user,
                  isArchived: post.isArchived,
                  comments: post.comments,
                  likes: post.likes,
                  dislikes: post.dislikes,
                );
                Navigator.pop(context, updatedPost); // Return updated post
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueGrey,
      ),
      body: posts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.post_add, size: 80, color: Colors.blueGrey),
                  SizedBox(height: 16),
                  Text(
                    "No Posts Available",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Add new posts to see them here.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth:
                      MediaQuery.of(context).size.width, // Full screen width
                ),
                child: DataTable(
                  columnSpacing: 20, // Adjust spacing between columns
                  horizontalMargin: 16,
                  headingRowColor: MaterialStateColor.resolveWith(
                      (states) => Colors.grey[200]!),
                  headingTextStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blueGrey),
                  columns: [
                    DataColumn(label: Text('Content')),
                    DataColumn(label: Text('User')),
                    DataColumn(label: Text('Likes')),
                    DataColumn(label: Text('Dislikes')),
                    DataColumn(
                        label: Text('Actions')), // New column for actions
                  ],
                  rows: posts.map((post) {
                    return DataRow(cells: [
                      DataCell(
                        Text(
                          post.content,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      DataCell(Text(post.user.name)), // Display user name
                      DataCell(Text(post.likes.length.toString())),
                      DataCell(Text(post.dislikes.length.toString())),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                _updatePost(post);
                              },
                              tooltip: 'Edit Post',
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _showDeleteConfirmationDialog(post);
                              },
                              tooltip: 'Delete Post',
                            ),
                          ],
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
    );
  }

  // Confirmation dialog before deleting a post
  void _showDeleteConfirmationDialog(Post post) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Delete Post",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            "Are you sure you want to delete the post '${post.content}'?",
            style: TextStyle(color: Colors.black87),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("Delete"),
              onPressed: () {
                Navigator.pop(context); // Close dialog
                _deletePost(post); // Perform deletion
              },
            ),
          ],
        );
      },
    );
  }
}
