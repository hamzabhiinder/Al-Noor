class Product {
  final String? id;
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
    this.id,
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
        id: json['id'] ?? '');
  }

  factory Product.fromImageJson(Map<String, dynamic> json) {
    return Product(
      productId: json['id'] ?? '',
      thumbnailImage: json['file_path'],
      productName: 'My Ideas',
      productSlug: '',
      productImage: json['file_path'].replaceFirst("https://alnoormdf.com", ""),
      productImage2: '',
      productImage3: '',
      productImage4: '',
      productType: '',
      productShortDesc: '',
      productRegPrice: '',
      productStatus: '',
      productCreatedAt: '',
      productUpdatedAt: '',
    );
  }
}
