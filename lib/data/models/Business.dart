import 'dart:convert';

class Business {
  String id = "";
  String nombreNegocio = "";
  String nombreDueno = "";
  String direccion = "";
  String correo = "";
  int telefono = 0;
  bool activo = false;

  Business({
    required this.id,
    required this.nombreNegocio,
    required this.nombreDueno,
    required this.direccion,
    required this.correo,
    required this.telefono,
    required this.activo,
  });

  Business copyWith({
    String? id,
    String? nombreNegocio,
    String? nombreDueno,
    String? direccion,
    String? correo,
    int? telefono,
    bool? activo,
  }) {
    return Business(
      id: id ?? this.id,
      nombreNegocio: nombreNegocio ?? this.nombreNegocio,
      nombreDueno: nombreDueno ?? this.nombreDueno,
      direccion: direccion ?? this.direccion,
      correo: correo ?? this.correo,
      telefono: telefono ?? this.telefono,
      activo: activo ?? this.activo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombreNegocio': nombreNegocio,
      'nombreDueno': nombreDueno,
      'direccion': direccion,
      'correo': correo,
      'telefono': telefono,
      'activo': activo,
    };
  }

  factory Business.fromMap(Map<String, dynamic> map) {
    return Business(
      id: map['id'],
      nombreNegocio: map['nombreNegocio'],
      nombreDueno: map['nombreDueno'],
      direccion: map['direccion'],
      correo: map['correo'],
      telefono: map['telefono'],
      activo: map['activo'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Business.fromJson(String source) => Business.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User( id: $id, nombreNegocio: $nombreNegocio, '
        '         nombreDueno: $nombreDueno, direccion: $direccion, correo: $correo,'
        '         telefono: $telefono, activo: $activo)';
  }
}
