import 'dart:convert';

class Business {
  String id = "";
  String nombreNegocio = "";
  String nombreDueno = "";
  String idDueno = "";
  String direccion = "";
  String correo = "";
  int telefono = 0;
  bool activo = false;
  List<String> empleados;

  Business({
    required this.id,
    required this.nombreNegocio,
    required this.nombreDueno,
    required this.idDueno,
    required this.direccion,
    required this.correo,
    required this.telefono,
    required this.activo,
    required this.empleados,
  });

  Business copyWith({
    String? id,
    String? nombreNegocio,
    String? nombreDueno,
    String? idDueno,
    String? direccion,
    String? correo,
    int? telefono,
    bool? activo,
    List<String>? empleados,
  }) {
    return Business(
      id: id ?? this.id,
      nombreNegocio: nombreNegocio ?? this.nombreNegocio,
      nombreDueno: nombreDueno ?? this.nombreDueno,
      idDueno: idDueno ?? this.idDueno,
      direccion: direccion ?? this.direccion,
      correo: correo ?? this.correo,
      telefono: telefono ?? this.telefono,
      activo: activo ?? this.activo,
      empleados: empleados ?? this.empleados,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombreNegocio': nombreNegocio,
      'nombreDueno': nombreDueno,
      'idDueno': idDueno,
      'direccion': direccion,
      'correo': correo,
      'telefono': telefono,
      'activo': activo,
      'empleados': empleados,
    };
  }

  factory Business.fromMap(Map<String, dynamic> map) {
    return Business(
      id: map['id'],
      nombreNegocio: map['nombreNegocio'],
      nombreDueno: map['nombreDueno'],
      idDueno: map['idDueno'],
      direccion: map['direccion'],
      correo: map['correo'],
      telefono: map['telefono'],
      activo: map['activo'],
      empleados: map['empleados']
    );
  }

  String toJson() => json.encode(toMap());

  factory Business.fromJson(String source) => Business.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User( id: $id, nombreNegocio: $nombreNegocio, nombreDueño: $nombreDueno, idDueño: $idDueno, direccion: $direccion, correo: $correo, telefono: $telefono, activo: $activo, empleados: $empleados)';
  }
}
