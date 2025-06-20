class Likecheckmodel {
  final String userId;
  final int postId;

  Likecheckmodel({required this.userId, required this.postId});

  factory Likecheckmodel.fromJson(Map<String, dynamic> json) {
    return Likecheckmodel(
        userId: json['userId'] as String, postId: json['postId'] as int);
  }
}
