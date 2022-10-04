import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gest_inventory/utils/extensions_functions.dart';

class Sales {
  String id;
  double units;
  Timestamp creationDate;

  static const FIELD_ID = "id";
  static const FIELD_UNITS = "units";
  static const FIELD_CREATION_DATE = "creationDate";

  Sales({
    this.id = "",
    this.units = 0.0,
    required this.creationDate,
  });

  Sales copyWith({
    String? id,
    double? units,
    Timestamp? creationDate,
  }) {
    return Sales(
      id: id ?? this.id,
      units: units ?? this.units,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'units': units,
      'creationDate': creationDate,
    };
  }

  factory Sales.fromMap(Map<String, dynamic> map) {
    return Sales(
      id: map['id'],
      creationDate: map['creationDate'],
      units: map['units'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Sales.fromJson(String source) => Sales.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Sales(id: $id, units: $units, creationDate: ${creationDate.toDate().toFormatDate()})';
  }
}