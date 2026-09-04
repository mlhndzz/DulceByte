class Producto {
  final int idProducto;
  final String nombre;
  final String descripcion;
  final double precio;
  final bool disponible;
  final int idCategoria;
  final String categoria;

  const Producto({
    required this.idProducto,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.disponible,
    required this.idCategoria,
    required this.categoria,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      idProducto: _asInt(json['idProducto']),
      nombre: json['nombre']?.toString() ?? '',
      descripcion: json['descripcion']?.toString() ?? '',
      precio: _asDouble(json['precio']),
      disponible: _asBool(json['disponible']),
      idCategoria: _asInt(json['idCategoria']),
      categoria: json['categoria']?.toString() ?? '',
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

  static bool _asBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    final normalized = value?.toString().toLowerCase();
    return normalized == 'true' || normalized == '1';
  }
}
