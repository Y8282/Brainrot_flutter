class Commentmodel {
  final int id;
  final int postId;
  final String userId;
  final String? content;
  final int? commentId;
  final String createdAt;
  final String updatedAt;
  final List<Commentmodel> replies;

  Commentmodel({
    required this.id,
    required this.postId,
    required this.userId,
    this.content,
    this.commentId,
    required this.createdAt,
    required this.updatedAt,
    this.replies = const [],
  });

  factory Commentmodel.fromJson(Map<String, dynamic> json) {
    return Commentmodel(
      id: json['id'] as int,
      postId: json['postId'] as int,
      userId: json['userId'] as String,
      content: json['content'] ?? '',
      commentId: json['commentId'] as int?,
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
    );
  }
}
