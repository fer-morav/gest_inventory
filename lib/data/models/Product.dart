import 'dart:convert';

class Product {
  String id = "";
  String idNegocio = "";
  String nombre = "";
  double precioUnitario = 0.0;
  double precioMayoreo = 0.0;
  double stock = 0.0;
  int ventaSemana = 0;
  int ventaMes = 0;

  static const FIELD_ID = "id";
  static const FIELD_BUSINESS_ID = "idNegocio";
  static const FIELD_NAME = "nombre";
  static const FIELD_UNIT_PRICE = "precioUnitario";
  static const FIELD_WHOLESALE_PRICE = "precioMayoreo";
  static const FIELD_STOCK = "stock";

  Product({
    required this.id,
    required this.idNegocio,
    required this.nombre,
    required this.precioUnitario,
    required this.precioMayoreo,
    required this.stock,
    required this.ventaSemana,
    required this.ventaMes,
  });

  Product copyWith({
    String? id,
    String? idNegocio,
    String? nombre,
    double? precioUnitario,
    double? precioMayoreo,
    double? stock,
    int? ventaSemana,
    int? ventaMes,
  }) {
    return Product(
      id: id ?? this.id,
      idNegocio: idNegocio?? this.idNegocio,
      nombre: nombre ?? this.nombre,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      precioMayoreo: precioMayoreo ?? this.precioMayoreo,
      stock: stock ?? this.stock,
      ventaMes: ventaMes ?? this.ventaMes,
      ventaSemana: ventaSemana ?? this.ventaSemana,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idNegocio': idNegocio,
      'nombre': nombre,
      'precioUnitario': precioUnitario,
      'precioMayoreo': precioMayoreo,
      'stock': stock,
      'ventaSemana': ventaSemana,
      'ventaMes': ventaMes,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      idNegocio: map['idNegocio'],
      nombre: map['nombre'],
      precioMayoreo: map['precioMayoreo'],
      precioUnitario: map['precioUnitario'],
      stock: map['stock'],
      ventaSemana: map['ventaSemana'],
      ventaMes: map['ventaMes'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) => Product.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, idNegocio: $idNegocio, nombre: $nombre, precioUnitario: $precioUnitario, precioMayoreo: $precioMayoreo, stock: $stock, ventaSemana: $ventaSemana, ventaMes: $ventaMes)';
  }
}