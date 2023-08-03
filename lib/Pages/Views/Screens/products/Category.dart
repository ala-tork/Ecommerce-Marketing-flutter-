class Categorie {
  final int id;
  final String? title;
  final String? description;
  final String? imageBase64;

  Categorie({
    required this.id,
    this.title,
    this.description,
    required this.imageBase64,
  });
  factory Categorie.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    return Categorie(
      id: id is int ? id : 0,
      title: json['title'] as String?,
      description: json['description'] as String?,
      imageBase64: json['imageBase64'] as String?,
    );
  }

}
