import 'dart:convert';

class Bussiness {
  String id = "";
  String idNegocio = "";
  String nombreNegocio = "";
  String nombreDueno = "";
  String direccion = "";
  String correo = "";
  int telefono = 0;
  bool activo = false;

  Bussiness({
    required this.id,
    required this.idNegocio,
    required this.nombreNegocio,
    required this.nombreDueno,
    required this.direccion,
    required this.correo,
    required this.telefono,
    required this.activo,
  });

  Bussiness copyWith({
    String? id,
    String? idNegocio,
    String? nombreNegocio,
    String? nombreDueno,
    String? direccion,
    String? correo,
    int? telefono,
    bool? activo,
  }) {
    return Bussiness(
      id: id ?? this.id,
      idNegocio: idNegocio?? this.idNegocio,
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
      'idNegocio': idNegocio,
      'nombreNegocio': nombreNegocio,
      'nombreDueno': nombreDueno,
      'direccion': direccion,
      'correo': correo,
      'telefono': telefono,
      'activo': activo,
    };
  }

  factory Bussiness.fromMap(Map<String, dynamic> map) {
    return Bussiness(
      id: map['id'],
      idNegocio: map['idNegocio'],
      nombreNegocio: map['nombreNegocio'],
      nombreDueno: map['nombreDueno'],
      direccion: map['direccion'],
      correo: map['correo'],
      telefono: map['telefono'],
      activo: map['activo'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Bussiness.fromJson(String source) => Bussiness.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User( id: $id, idNegocio: $idNegocio, nombreNegocio: $nombreNegocio, '
        '         nombreDueno: $nombreDueno, direccion: $direccion, correo: $correo,'
        '         telefono: $telefono, activo: $activo)';
  }
}
