import 'dart:convert';

class Incomings {
  String id = "";
  String idProducto = "";
  String idNegocio = "";
  String nombreProducto = "";
  String fecha = "";
  double precioUnitario = 0.0;
  double precioMayoreo = 0.0;
  double unidadesCompradas = 0.0;

  Incomings({
    required this.id,
    required this.idProducto,
    required this.idNegocio,
    required this.nombreProducto,
    required this.fecha,
    required this.precioUnitario,
    required this.precioMayoreo,
    required this.unidadesCompradas,
  });

  Incomings copyWith({
    String? id,
    String? idProducto,
    String? idNegocio,
    String? nombreProducto,
    String? fecha,
    double? precioUnitario,
    double? precioMayoreo,
    double? unidadesCompradas,
  }) {
    return Incomings(
        id: id ?? this.id,
        idProducto: idProducto?? this.idProducto,
        idNegocio: idNegocio?? this.idNegocio,
        nombreProducto: nombreProducto ?? this.nombreProducto,
        fecha: fecha ?? this.fecha,
        precioUnitario: precioUnitario ?? this.precioUnitario,
        precioMayoreo: precioMayoreo ?? this.precioMayoreo,
        unidadesCompradas: unidadesCompradas ?? this.unidadesCompradas,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idProducto': idProducto,
      'idNegocio': idNegocio,
      'nombreProducto': nombreProducto,
      'fecha': fecha,
      'precioUnitario': precioUnitario,
      'precioMayoreo': precioMayoreo,
      'unidadesCompradas': unidadesCompradas,
    };
  }

  factory Incomings.fromMap(Map<String, dynamic> map) {
    return Incomings(
        id: map['id'],
        idProducto: map['idProducto'],
        idNegocio: map['idNegocio'],
        nombreProducto: map['nombreProducto'],
        fecha: map['fecha'],
        precioMayoreo: map['precioMayoreo'],
        precioUnitario: map['precioUnitario'],
        unidadesCompradas: map['unidadesCompradas']
    );
  }

  String toJson() => json.encode(toMap());

  factory Incomings.fromJson(String source) => Incomings.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, idProducto: $idProducto, idNegocio: $idNegocio, nombre: $nombreProducto, fecha: $fecha, precioUnitario: $precioUnitario, precioMayoreo: $precioMayoreo,  unidadesCompradas: $unidadesCompradas)';
  }
}