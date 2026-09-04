class DetallePedido {
  final int idDetalle;
  final int idProducto;
  final String producto;
  final int cantidad;
  final double precioUnitario;
  final double subtotal;

  const DetallePedido({
    required this.idDetalle,
    required this.idProducto,
    required this.producto,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
  });

  factory DetallePedido.fromJson(Map<String, dynamic> json) {
    return DetallePedido(
      idDetalle: _asInt(json['idDetalle']),
      idProducto: _asInt(json['idProducto']),
      producto: json['producto']?.toString() ?? '',
      cantidad: _asInt(json['cantidad']),
      precioUnitario: _asDouble(json['precioUnitario']),
      subtotal: _asDouble(json['subtotal']),
    );
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _asDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}
