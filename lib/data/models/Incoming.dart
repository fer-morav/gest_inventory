import 'dart:convert';

class Incomings {
  String id = "";
  String idNegocio = "";
  String nombreProducto = "";
  double precioUnitario = 0.0;
  double precioMayoreo = 0.0;
  double unidadesCompradas = 0.0;

  Incomings({
    required this.id,
    required this.idNegocio,
    required this.nombreProducto,
    required this.precioUnitario,
    required this.precioMayoreo,
    required this.unidadesCompradas,
  });

  Incomings copyWith({
    String? id,
    String? idNegocio,
    String? nombreProducto,
    double? precioUnitario,
    double? precioMayoreo,
    double? unidadesCompradas,
  }) {
    return Incomings(
        id: id ?? this.id,
        idNegocio: idNegocio?? this.idNegocio,
        nombreProducto: nombreProducto ?? this.nombreProducto,
        precioUnitario: precioUnitario ?? this.precioUnitario,
        precioMayoreo: precioMayoreo ?? this.precioMayoreo,
        unidadesCompradas: unidadesCompradas ?? this.unidadesCompradas,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idNegocio': idNegocio,
      'nombreProducto': nombreProducto,
      'precioUnitario': precioUnitario,
      'precioMayoreo': precioMayoreo,
      'unidadesCompradas': unidadesCompradas,
    };
  }

  factory Incomings.fromMap(Map<String, dynamic> map) {
    return Incomings(
        id: map['id'],
        idNegocio: map['idNegocio'],
        nombreProducto: map['nombreProducto'],
        precioMayoreo: map['precioMayoreo'],
        precioUnitario: map['precioUnitario'],
        unidadesCompradas: map['unidadesCompradas']
    );
  }

  String toJson() => json.encode(toMap());

  factory Incomings.fromJson(String source) => Incomings.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, idNegocio: $idNegocio, nombre: $nombreProducto, precioUnitario: $precioUnitario, precioMayoreo: $precioMayoreo,  unidadesCompradas: $unidadesCompradas)';
  }
}