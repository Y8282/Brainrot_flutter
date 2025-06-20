class Postmodel {
  final int id;
  final String title;
  final String content;
  final int? imgId;
  final String author;
  final String? image;
  final String username;
  final bool? liked;
  final DateTime createdAt;
  final DateTime updatedAt;

  Postmodel({
    required this.id,
    required this.title,
    required this.content,
    this.imgId,
    required this.author,
    this.image,
    required this.username,
    this.liked,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Postmodel.fromJson(Map<String, dynamic> json) {
    return Postmodel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      imgId: json['imgId'],
      author: json['author'],
      image: json['image'],
      username: json['username'],
      liked :json['liked'] ?? false,
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}
