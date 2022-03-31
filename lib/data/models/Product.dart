import 'dart:convert';

class Product {
  String id = "";
  String idNegocio = "";
  String codigoBarras = "";
  String marca = "";
  String nombre = "";

  int precioUnidad = 0;
  int precioMayoreo = 0;
  int existencias = 0;


  Product({
    required this.id,
    required this.idNegocio,
    required this.codigoBarras,
    required this.marca,
    required this.nombre,
    required this.precioUnidad,
    required this.precioMayoreo,
    required this.existencias,
  });

  Product copyWith({
    String? id,
    String? idNegocio,
    String? codigoBarras,
    String? marca,
    String? nombre,
    int? precioUnidad,
    int? precioMayoreo,
    int? existencias,
  }) {
    return Product(
      id: id ?? this.id,
      idNegocio: idNegocio?? this.idNegocio,
      codigoBarras: codigoBarras ?? this.codigoBarras,
      marca: marca ?? this.marca,
      nombre: nombre ?? this.nombre,
      precioUnidad: precioUnidad ?? this.precioUnidad,
      precioMayoreo: precioMayoreo ?? this.precioMayoreo,
      existencias: existencias ?? this.existencias,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idNegocio': idNegocio,
      'codigoBarras': codigoBarras,
      'marca': marca,
      'nombre': nombre,
      'precioUnidad': precioUnidad,
      'precioMayoreo': precioMayoreo,
      'existencias': existencias,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      idNegocio: map['idNegocio'],
      codigoBarras: map['codigoBarras'],
      marca: map['marca'],
      nombre: map['nombre'],
      precioUnidad: map['precioUnidad'],
      precioMayoreo: map['precioMayoreo'],
      existencias: map['existencias'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) => Product.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User( id: $id, idNegocio: $idNegocio, codigoBarras: $codigoBarras, '
        '         marca: $marca, nombre: $nombre, precioUnidad: $precioUnidad,'
        '         precioMayoreo: $precioMayoreo, existencias: $existencias)';
  }
}
