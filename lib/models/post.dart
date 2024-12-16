import 'user.dart'; // Import the User model

class Post {
  final String id;
  final String content;
  final User user; // Change type to User
  final bool isArchived;
  final List<Comment> comments;
  final List<String> likes;
  final List<String> dislikes;

  Post({
    required this.id,
    required this.content,
    required this.user, // Change type to User
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
      id: json['_id'],
      content: json['content'],
      user: User.fromJson(json['user']), // Parse user as User
      isArchived: json['isArchived'],
      comments: comments,
      likes: List<String>.from(json['likes']),
      dislikes: List<String>.from(json['dislikes']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'content': content,
      'user': user.toJson(), // Convert user to JSON
      'isArchived': isArchived,
      'comments': comments.map((comment) => comment.toJson()).toList(),
      'likes': likes,
      'dislikes': dislikes,
    };
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

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'user': user,
    };
  }
}
