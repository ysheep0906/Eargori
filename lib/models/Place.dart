class Place {
  String id;
  String author;
  String place;
  List<String> sentences;

  Place({
    required this.id,
    required this.author,
    required this.place,
    required this.sentences,
  });

  // JSON serialization
  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['_id'] as String,
      author: json['author'] as String,
      place: json['place'] as String,
      sentences: List<String>.from(json['sentences']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'author': author,
      'place': place,
      'sentences': sentences,
    };
  }

  // Method to add a sentence
  void addSentence(String sentenceId) {
    if (!sentences.contains(sentenceId)) {
      sentences.add(sentenceId);
    }
  }

  // Method to remove a sentence
  void removeSentence(String sentenceId) {
    sentences.remove(sentenceId);
  }
}
