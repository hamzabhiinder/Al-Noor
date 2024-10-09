// models/product.dart

class Product {
  final String productId;
  final String thumbnailImage;
  final String productName;
  final String productSlug;
  final String productImage;
  final String productImage2;
  final String productImage3;
  final String productImage4;
  final String productType;
  final String productShortDesc;
  final String productRegPrice;
  final String productStatus;
  final String productCreatedAt;
  final String productUpdatedAt;

  Product({
    required this.productId,
    required this.thumbnailImage,
    required this.productName,
    required this.productSlug,
    required this.productImage,
    this.productImage2 = '',
    this.productImage3 = '',
    this.productImage4 = '',
    required this.productType,
    required this.productShortDesc,
    required this.productRegPrice,
    required this.productStatus,
    required this.productCreatedAt,
    required this.productUpdatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['product_id'] ?? '',
      thumbnailImage: "https://alnoormdf.com/" + json['thumbnail_image'],
      productName: json['product_name'] ?? '',
      productSlug: json['product_slug'] ?? '',
      productImage: json['product_image'] ?? '',
      productImage2: json['product_image2'] ?? '',
      productImage3: json['product_image3'] ?? '',
      productImage4: json['product_image4'] ?? '',
      productType: json['product_type'] ?? '',
      productShortDesc: json['product_short_desc'] ?? '',
      productRegPrice: json['product_reg_price'] ?? '',
      productStatus: json['product_status'] ?? '',
      productCreatedAt: json['product_created_at'] ?? '',
      productUpdatedAt: json['product_updated_at'] ?? '',
    );
  }

  // Convert Product to Map
  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'thumbnail_image': thumbnailImage,
      'product_name': productName,
      'product_slug': productSlug,
      'product_image': productImage,
      'product_image2': productImage2,
      'product_image3': productImage3,
      'product_image4': productImage4,
      'product_type': productType,
      'product_short_desc': productShortDesc,
      'product_reg_price': productRegPrice,
      'product_status': productStatus,
      'product_created_at': productCreatedAt,
      'product_updated_at': productUpdatedAt,
    };
  }

  // Create Product from Map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      productId: map['product_id'] ?? '',
      thumbnailImage: map['thumbnail_image'] ?? '',
      productName: map['product_name'] ?? '',
      productSlug: map['product_slug'] ?? '',
      productImage: map['product_image'] ?? '',
      productImage2: map['product_image2'] ?? '',
      productImage3: map['product_image3'] ?? '',
      productImage4: map['product_image4'] ?? '',
      productType: map['product_type'] ?? '',
      productShortDesc: map['product_short_desc'] ?? '',
      productRegPrice: map['product_reg_price'] ?? '',
      productStatus: map['product_status'] ?? '',
      productCreatedAt: map['product_created_at'] ?? '',
      productUpdatedAt: map['product_updated_at'] ?? '',
    );
  }
}
