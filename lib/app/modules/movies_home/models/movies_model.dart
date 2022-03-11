class MoviesModel {
  final int id;
  final String image;

  MoviesModel({
    required this.id,
    required this.image,
  });

  factory MoviesModel.fromMap(Map<String, dynamic> json) => MoviesModel(
        id: json['id'],
        image: json['image'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
    };
  }
}
