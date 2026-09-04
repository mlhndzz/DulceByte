import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/cliente.dart';
import '../models/pedido.dart';

class PedidoService {
  final http.Client _client;

  PedidoService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Cliente>> listarClientes() async {
    try {
      final response = await _client
          .get(
            Uri.parse('${ApiConfig.baseUrl}/api/clientes'),
            headers: const {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('No se pudieron consultar los clientes.');
      }

      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is! List) {
        throw Exception('La respuesta de clientes no tiene el formato esperado.');
      }

      return decoded
          .whereType<Map<String, dynamic>>()
          .map(Cliente.fromJson)
          .toList();
    } on TimeoutException {
      throw Exception('La API tardó demasiado en responder.');
    } on FormatException {
      throw Exception('La API devolvió datos inválidos.');
    } on http.ClientException {
      throw Exception('No fue posible conectar con la API de DulceByte.');
    }
  }

  Future<Pedido> crearPedido(int idCliente) async {
    try {
      final response = await _client
          .post(
            Uri.parse('${ApiConfig.baseUrl}/api/pedidos'),
            headers: const {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({'idCliente': idCliente}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200 && response.statusCode != 201) {
        final message = _readApiMessage(response.bodyBytes);
        throw Exception(message ?? 'No se pudo crear el pedido.');
      }

      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is! Map<String, dynamic>) {
        throw Exception('La respuesta del pedido no tiene el formato esperado.');
      }

      return Pedido.fromJson(decoded);
    } on TimeoutException {
      throw Exception('La API tardó demasiado en responder.');
    } on FormatException {
      throw Exception('La API devolvió datos inválidos.');
    } on http.ClientException {
      throw Exception('No fue posible conectar con la API de DulceByte.');
    }
  }

  Future<Pedido> agregarDetalle({
    required int idPedido,
    required int idProducto,
    required int cantidad,
  }) async {
    try {
      final response = await _client
          .post(
            Uri.parse('${ApiConfig.baseUrl}/api/pedidos/$idPedido/detalle'),
            headers: const {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'idProducto': idProducto,
              'cantidad': cantidad,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        final message = _readApiMessage(response.bodyBytes);
        throw Exception(message ?? 'No se pudo agregar el producto al pedido.');
      }

      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is! Map<String, dynamic>) {
        throw Exception('La respuesta del pedido no tiene el formato esperado.');
      }

      return Pedido.fromJson(decoded);
    } on TimeoutException {
      throw Exception('La API tardó demasiado en responder.');
    } on FormatException {
      throw Exception('La API devolvió datos inválidos.');
    } on http.ClientException {
      throw Exception('No fue posible conectar con la API de DulceByte.');
    }
  }

  String? _readApiMessage(List<int> bytes) {
    try {
      final decoded = jsonDecode(utf8.decode(bytes));
      if (decoded is Map<String, dynamic>) {
        final value = decoded['message'] ?? decoded['mensaje'] ?? decoded['detail'];
        return value?.toString();
      }
    } catch (_) {}
    return null;
  }
}
