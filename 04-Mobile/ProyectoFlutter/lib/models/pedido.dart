import 'detalle_pedido.dart';

class Pedido {
  final int idPedido;
  final String fecha;
  final double total;
  final int idCliente;
  final String cliente;
  final int idEstado;
  final String estado;
  final List<DetallePedido> detalles;

  const Pedido({
    required this.idPedido,
    required this.fecha,
    required this.total,
    required this.idCliente,
    required this.cliente,
    required this.idEstado,
    required this.estado,
    required this.detalles,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    final detallesJson = json['detalles'];

    return Pedido(
      idPedido: _asInt(json['idPedido']),
      fecha: json['fecha']?.toString() ?? '',
      total: _asDouble(json['total']),
      idCliente: _asInt(json['idCliente']),
      cliente: json['cliente']?.toString() ?? '',
      idEstado: _asInt(json['idEstado']),
      estado: json['estado']?.toString() ?? '',
      detalles: detallesJson is List
          ? detallesJson
              .whereType<Map<String, dynamic>>()
              .map(DetallePedido.fromJson)
              .toList()
          : const [],
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
