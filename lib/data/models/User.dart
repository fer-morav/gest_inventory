import 'dart:convert';

class User {
  String id = "";
  String idNegocio = "";
  String cargo = "";
  String nombre = "";
  String apellidos = "";
  int telefono = 0;
  double salario = 0.0;

  static const FIELD_ID = "id";
  static const FIELD_ID_BUSINESS = "idNegocio";
  static const FIELD_POSITION = "cargo";
  static const FIELD_NAME = "nombre";
  static const FIELD_LASTNAME = "apellido";
  static const FIELD_PHONE = "telefono";
  static const FIELD_PAY = "salario";

  User({
    required this.id,
    required this.idNegocio,
    required this.cargo,
    required this.nombre,
    required this.apellidos,
    required this.telefono,
    required this.salario,
  });

  User copyWith({
    String? id,
    String? idNegocio,
    String? cargo,
    String? nombre,
    String? apellidos,
    int? telefono,
    double? salario,
  }) {
    return User(
      id: id ?? this.id,
      idNegocio: idNegocio?? this.idNegocio,
      cargo: cargo ?? this.cargo,
      nombre: nombre ?? this.nombre,
      apellidos: apellidos ?? this.apellidos,
      telefono: telefono ?? this.telefono,
      salario: salario ?? this.salario,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idNegocio': idNegocio,
      'cargo': cargo,
      'nombre': nombre,
      'apellidos': apellidos,
      'telefono': telefono,
      'salario': salario,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      idNegocio: map['idNegocio'],
      cargo: map['cargo'],
      nombre: map['nombre'],
      apellidos: map['apellidos'],
      telefono: map['telefono'],
      salario: map['salario'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, idNegocio: $idNegocio, cargo: $cargo, nombre: $nombre, apellidos: $apellidos, telefono: $telefono, salario: $salario)';
  }
}
