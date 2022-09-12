import 'dart:convert';
import 'package:gest_inventory/utils/resources.dart';

class User {
  String id;
  String idBusiness;
  String name;
  String email;
  String photoUrl;
  bool admin;
  int phoneNumber;
  double salary;
  bool available;

  static const FIELD_ID = "id";
  static const FIELD_ID_BUSINESS = "idBusiness";
  static const FIELD_NAME = "name";
  static const FIELD_ADMIN = "admin";
  static const FIELD_PHOTO = "photoUrl";
  static const FIELD_PHONE = "phoneNumber";
  static const FIELD_SALARY = "salary";
  static const FIELD_AVAILABLE = "available";

  User({
    this.id = '',
    this.idBusiness = '',
    this.name = '',
    this.email = '',
    this.photoUrl = image_profile_default,
    this.admin = false,
    this.phoneNumber = 0,
    this.salary = 0.0,
    this.available = false,
  });

  User copyWith({
    String? id,
    String? idBusiness,
    String? name,
    String? email,
    String? photoUrl,
    bool? admin,
    int? phoneNumber,
    double? salary,
    bool? available,
  }) {
    return User(
      id: id ?? this.id,
      idBusiness: idBusiness ?? this.idBusiness,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      admin: admin ?? this.admin,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      salary: salary ?? this.salary,
      available: available ?? this.available,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idBusiness': idBusiness,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'admin': admin,
      'phoneNumber': phoneNumber,
      'salary': salary,
      'available': available,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      idBusiness: map['idBusiness'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'] ?? image_profile_default,
      admin: map['admin'] ?? false,
      phoneNumber: map['phoneNumber'] ?? 0,
      salary: map['salary'] ?? 0,
      available: map['available'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, idBusiness: $idBusiness, name: $name, email: $email, photoUrl: $photoUrl, admin: $admin, phoneNumber: $phoneNumber, salary: $salary, available: $available)';
  }
}
