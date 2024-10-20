class Moodboard {
  final String id;
  final String name;
  final String image1;
  final String image2;
  final String image3;
  final String image4;

  Moodboard({
    required this.id,
    required this.name,
    required this.image1,
    required this.image2,
    required this.image3,
    required this.image4,
  });

  factory Moodboard.fromJson(Map<String, dynamic> json) {
    return Moodboard(
      id: json['id'],
      name: json['name'],
      image1: json['image1'] ?? "",
      image2: json['image2'] ?? "",
      image3: json['image3'] ?? "",
      image4: json['image4'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image1': image1,
      'image2': image2,
      'image3': image3,
      'image4': image4,
    };
  }
}
