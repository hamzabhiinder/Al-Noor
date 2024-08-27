import 'package:hive/hive.dart';
import 'package:alnoor/models/product.dart';

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 0;

  @override
  Product read(BinaryReader reader) {
    return Product(
      productId: reader.readString(),
      thumbnailImage: reader.readString(),
      productName: reader.readString(),
      productSlug: reader.readString(),
      productImage: reader.readString(),
      productImage2: reader.readString(),
      productImage3: reader.readString(),
      productImage4: reader.readString(),
      productType: reader.readString(),
      productShortDesc: reader.readString(),
      productRegPrice: reader.readString(),
      productStatus: reader.readString(),
      productCreatedAt: reader.readString(),
      productUpdatedAt: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer.writeString(obj.productId);
    writer.writeString(obj.thumbnailImage);
    writer.writeString(obj.productName);
    writer.writeString(obj.productSlug);
    writer.writeString(obj.productImage);
    writer.writeString(obj.productImage2);
    writer.writeString(obj.productImage3);
    writer.writeString(obj.productImage4);
    writer.writeString(obj.productType);
    writer.writeString(obj.productShortDesc);
    writer.writeString(obj.productRegPrice);
    writer.writeString(obj.productStatus);
    writer.writeString(obj.productCreatedAt);
    writer.writeString(obj.productUpdatedAt);
  }
}
