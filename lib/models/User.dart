class User {
  String id;
  final String username;
  final String password;
  final String nickname;
  final List<String> favoriteSentences;
  final List<String> places;
  String token;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.nickname,
    required this.favoriteSentences,
    required this.places,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      nickname: json['nickname'] as String,
      favoriteSentences: List<String>.from(json['favoriteSentences']),
      places: List<String>.from(json['places']),
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'password': password,
      'nickname': nickname,
      'favoriteSentences': favoriteSentences,
      'places': places,
      'token': token,
    };
  }

  void favorite(String sentenceId) {
    if (!favoriteSentences.contains(sentenceId)) {
      favoriteSentences.add(sentenceId);
    }
  }

  void unfavorite(String sentenceId) {
    favoriteSentences.remove(sentenceId);
  }

  // Method to update places
  void savePlace(String placeId) {
    if (!places.contains(placeId)) {
      places.add(placeId);
    }
  }

  void removePlace(String placeId) {
    places.remove(placeId);
  }

  // Method to search place
  String? searchPlace(String place) {
    return places.contains(place) ? place : null;
  }
}
