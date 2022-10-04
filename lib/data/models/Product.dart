import 'dart:convert';
import '../../utils/resources.dart';

class Product {
  String id;
  String businessId;
  String barcode;
  String name;
  String description;
  double unitPrice;
  double wholesalePrice;
  double stock;
  String photoUrl;

  static const FIELD_ID = "id";
  static const FIELD_BUSINESS_ID = "businessId";
  static const FIELD_BARCODE = "barcode";
  static const FIELD_NAME = "name";
  static const FIELD_DESCRIPTION = "description";
  static const FIELD_UNIT_PRICE = "unitPrice";
  static const FIELD_WHOLESALE_PRICE = "wholesalePrice";
  static const FIELD_STOCK = "stock";
  static const FIELD_URL_PHOTOS = "photoUrl";

  Product({
    this.id = "",
    this.businessId = "",
    this.barcode = "",
    this.name = "",
    this.description = "",
    this.unitPrice = 0.0,
    this.wholesalePrice = 0.0,
    this.stock = 0.0,
    this.photoUrl = image_product_default,
  });

  Product copyWith({
    String? id,
    String? businessId,
    String? barcode,
    String? name,
    String? description,
    double? unitPrice,
    double? wholesalePrice,
    double? stock,
    String? photoUrl,
  }) {
    return Product(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      barcode: barcode ?? this.barcode,
      name: name ?? this.name,
      description: description ?? this.description,
      unitPrice: unitPrice ?? this.unitPrice,
      wholesalePrice: wholesalePrice ?? this.wholesalePrice,
      stock: stock ?? this.stock,
      photoUrl: photoUrl ?? this.photoUrl
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'businessId': businessId,
      'barcode': barcode,
      'name': name,
      'description': description,
      'unitPrice': unitPrice,
      'wholesalePrice': wholesalePrice,
      'stock': stock,
      'photoUrl': photoUrl,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      businessId: map['businessId'] ?? '',
      barcode: map['barcode'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      unitPrice: map['unitPrice'] ?? 0,
      wholesalePrice: map['wholesalePrice'] ?? 0,
      stock: map['stock'] ?? 0,
      photoUrl: map['photoUrl'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) => Product.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Product{id: $id, businessId: $businessId, barcode: $barcode, name: $name, description: $description, unitPrice: $unitPrice, wholesalePrice: $wholesalePrice, stock: $stock, photoUrl: $photoUrl}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          businessId == other.businessId &&
          barcode == other.barcode &&
          name == other.name &&
          description == other.description &&
          unitPrice == other.unitPrice &&
          wholesalePrice == other.wholesalePrice &&
          stock == other.stock &&
          photoUrl == other.photoUrl;

  @override
  int get hashCode =>
      id.hashCode ^
      businessId.hashCode ^
      barcode.hashCode ^
      name.hashCode ^
      description.hashCode ^
      unitPrice.hashCode ^
      wholesalePrice.hashCode ^
      stock.hashCode ^
      photoUrl.hashCode;
}