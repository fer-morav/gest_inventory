import 'dart:convert';
import 'package:gest_inventory/data/models/Address.dart';
import 'package:gest_inventory/utils/resources.dart';

class Business {
  String id;
  String ownerId;
  String name;
  String photoUrl;
  String rfc;
  int phone;
  Address address;

  static const FIELD_ID = "id";
  static const FIELD_ID_OWNER = "ownerId";
  static const FIELD_NAME = "name";
  static const FIELD_PHOTO = "photoUrl";
  static const FIELD_PHONE = "phoneNumber";

  Business({
    this.id = '',
    this.ownerId = '',
    required this.address,
    this.name = '',
    this.photoUrl = image_business_default,
    this.rfc = '',
    this.phone = 0,
  });

  Business copyWith({
    String? id,
    String? ownerId,
    String? name,
    String? photoUrl,
    String? rfc,
    int? phone,
    Address? address,
  }) {
    return Business(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      address: address ?? this.address,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      rfc: rfc ?? this.rfc,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerId': ownerId,
      'address': address.toMap(),
      'name': name,
      'photoUrl': photoUrl,
      'rfc': rfc,
      'phone': phone,
    };
  }

  factory Business.fromMap(Map<String, dynamic> map) {
    return Business(
      id: map['id'],
      ownerId: map['ownerId'],
      address: Address.fromMap(map['address']),
      name: map['name'],
      photoUrl: map['photoUrl'],
      rfc: map['rfc'],
      phone: map['phone'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Business.fromJson(String source) => Business.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Business( id: $id, ownerId: $ownerId, address: $address, name: $name, photoUrl: $photoUrl, rfc: $rfc, phone: $phone )';
  }
}
