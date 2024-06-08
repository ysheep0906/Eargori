class Article {
  String id;
  String title;
  String description;
  String content; // This will store the ID of the Place
  String author; // This will store the ID of the User
  DateTime createdAt;
  DateTime updatedAt;

  Article({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.author,
    required this.createdAt,
    required this.updatedAt,
  });

  // JSON serialization
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      content: json['content'] as String,
      author: json['author'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'content': content,
      'author': author,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
