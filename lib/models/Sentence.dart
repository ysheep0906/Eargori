class Sentence {
  String id;
  String author; 
  String sentence;
  bool favorite;

  Sentence({
    required this.id,
    required this.author,
    required this.sentence,
    this.favorite = false,
  });

  // JSON serialization
  factory Sentence.fromJson(Map<String, dynamic> json) {
    return Sentence(
      id: json['_id'] as String,
      author: json['author'] as String,
      sentence: json['sentence'] as String,
      favorite: json['favorite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'author': author,
      'sentence': sentence,
      'favorite': favorite,
    };
  }

  // Method to toggle favorite
  void toggleFavorite() {
    favorite = !favorite;
  }
}
