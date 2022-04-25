import 'dart:convert';

class Sales {
  String id = "";
  String idNegocio = "";
  String nombreProducto = "";
  double precioUnitario = 0.0;
  double precioMayoreo = 0.0;
  int ventasUnitario = 0;
  int ventasMayoreo = 0;
  double total = 0.0;

  static const VENTAS_UNITARIO = "ventasUnitario";
  static const VENTAS_MAYOREO = "ventasMayoreo";
  static const TOTAL = "total";

  Sales({
    this.id = "",
    this.idNegocio = "",
    this.nombreProducto = "",
    this.precioUnitario = 0.0,
    this.precioMayoreo = 0.0,
    this.ventasUnitario = 0,
    this.ventasMayoreo = 0,
    this.total = 0,
  });

  Sales copyWith({
    String? id,
    String? idNegocio,
    String? nombreProducto,
    double? precioUnitario,
    double? precioMayoreo,
    int? ventasUnitario,
    int? ventasMayoreo,
    double? total,
  }) {
    return Sales(
      id: id ?? this.id,
      idNegocio: idNegocio?? this.idNegocio,
      nombreProducto: nombreProducto ?? this.nombreProducto,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      precioMayoreo: precioMayoreo ?? this.precioMayoreo,
      ventasUnitario: ventasUnitario ?? this.ventasUnitario,
      ventasMayoreo: ventasMayoreo ?? this.ventasMayoreo,
      total: total ?? this.total
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idNegocio': idNegocio,
      'nombreProducto': nombreProducto,
      'precioUnitario': precioUnitario,
      'precioMayoreo': precioMayoreo,
      'ventasUnitario': ventasUnitario,
      'ventasMayoreo': ventasMayoreo,
      'total': total,
    };
  }

  factory Sales.fromMap(Map<String, dynamic> map) {
    return Sales(
      id: map['id'],
      idNegocio: map['idNegocio'],
      nombreProducto: map['nombreProducto'],
      precioMayoreo: map['precioMayoreo'],
      precioUnitario: map['precioUnitario'],
      ventasUnitario: map['ventasUnitario'],
      ventasMayoreo: map['ventasMayoreo'],
      total: map['total']
    );
  }

  String toJson() => json.encode(toMap());

  factory Sales.fromJson(String source) => Sales.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, idNegocio: $idNegocio, nombre: $nombreProducto, precioUnitario: $precioUnitario, precioMayoreo: $precioMayoreo, ventasMayoreo: $ventasMayoreo, ventasUnitario: $ventasUnitario, total: $total)';
  }
}