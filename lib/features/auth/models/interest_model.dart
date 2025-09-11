class InterestModel {
  final int id;
  final String name;
  final String? imageUrl;
  final String? description;

  InterestModel(
      {required this.id, required this.name, this.imageUrl, this.description});

  factory InterestModel.fromJson(Map<String, dynamic> json) {
    return InterestModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image'],
      description: json['description'],
    );
  }
}
