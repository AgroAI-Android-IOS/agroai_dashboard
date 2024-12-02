class Post {
  final String id; // Add this field
  final String title;
  final String content;
  final String user;
  final bool isArchived;
  final List<Comment> comments;
  final List<String> likes;
  final List<String> dislikes;

  Post({
    required this.id, // Add this parameter
    required this.title,
    required this.content,
    required this.user,
    required this.isArchived,
    required this.comments,
    required this.likes,
    required this.dislikes,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    var commentsList = json['comments'] as List;
    List<Comment> comments =
        commentsList.map((i) => Comment.fromJson(i)).toList();

    return Post(
      id: json['_id'], // Map `_id` from the backend to `id`
      title: json['title'],
      content: json['content'],
      user: json['user'],
      isArchived: json['isArchived'],
      comments: comments,
      likes: List<String>.from(json['likes']),
      dislikes: List<String>.from(json['dislikes']),
    );
  }
}

class Comment {
  final String content;
  final String user;

  Comment({required this.content, required this.user});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      content: json['content'],
      user: json['user'],
    );
  }
}
