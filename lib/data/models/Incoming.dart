import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gest_inventory/utils/extensions_functions.dart';

class Incoming {
  String id = "";
  double units = 0.0;
  Timestamp creationDate;

  static const FIELD_ID = "id";
  static const FIELD_UNITS = "units";
  static const FIELD_CREATION_DATE = "creationDate";

  Incoming({
    this.id = "",
    this.units = 0.0,
    required this.creationDate,
  });

  Incoming copyWith({
    String? id,
    double? units,
    Timestamp? creationDate,
  }) {
    return Incoming(
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

  factory Incoming.fromMap(Map<String, dynamic> map) {
    return Incoming(
      id: map['id'],
      creationDate: map['creationDate'],
      units: map['units'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Incoming.fromJson(String source) => Incoming.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Sales(id: $id, units: $units, creationDate: ${creationDate.toDate().toFormatDate()})';
  }
}