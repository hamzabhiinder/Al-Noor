// models/category.dart

class Category {
  final String id;
  final String name;
  final String slug;
  final String image;
  final String status;
  final String createdAt;
  final String updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['category_id'],
      name: json['category_name'],
      slug: json['category_slug'],
      image: json['category_image'],
      status: json['category_status'],
      createdAt: json['category_created_at'],
      updatedAt: json['category_updated_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'image': image,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      slug: map['slug'],
      image: map['image'],
      status: map['status'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }
}
