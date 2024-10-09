// models/subcategory.dart

class Subcategory {
  final String sub_category_id;
  final String category_id;
  final String sub_category_name;
  final String sub_category_slug;
  final String sub_category_status;
  final String sub_category_created_at;
  final String sub_category_updated_at;

  Subcategory({
    required this.sub_category_id,
    required this.category_id,
    required this.sub_category_name,
    required this.sub_category_slug,
    required this.sub_category_status,
    required this.sub_category_created_at,
    required this.sub_category_updated_at,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      sub_category_id: json['sub_category_id'],
      category_id: json['category_id'],
      sub_category_name: json['sub_category_name'],
      sub_category_slug: json['sub_category_slug'],
      sub_category_status: json['sub_category_status'],
      sub_category_created_at: json['sub_category_created_at'],
      sub_category_updated_at: json['sub_category_updated_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sub_category_id': sub_category_id,
      'category_id': category_id,
      'sub_category_name': sub_category_name,
      'sub_category_slug': sub_category_slug,
      'sub_category_status': sub_category_status,
      'sub_category_created_at': sub_category_created_at,
      'sub_category_updated_at': sub_category_updated_at,
    };
  }

  factory Subcategory.fromMap(Map<String, dynamic> map) {
    return Subcategory(
      sub_category_id: map['sub_category_id'],
      category_id: map['category_id'],
      sub_category_name: map['sub_category_name'],
      sub_category_slug: map['sub_category_slug'],
      sub_category_status: map['sub_category_status'],
      sub_category_created_at: map['sub_category_created_at'],
      sub_category_updated_at: map['sub_category_updated_at'],
    );
  }
}
