import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/producto.dart';

class ProductoService {
  final http.Client _client;

  ProductoService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Producto>> listar() async {
    try {
      final response = await _client
          .get(
            Uri.parse('${ApiConfig.baseUrl}/api/productos'),
            headers: const {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('No se pudieron consultar los productos.');
      }

      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is! List) {
        throw Exception('La respuesta de productos no tiene el formato esperado.');
      }

      return decoded
          .whereType<Map<String, dynamic>>()
          .map(Producto.fromJson)
          .toList();
    } on TimeoutException {
      throw Exception('La API tardó demasiado en responder.');
    } on FormatException {
      throw Exception('La API devolvió datos inválidos.');
    } on http.ClientException {
      throw Exception('No fue posible conectar con la API de DulceByte.');
    }
  }
}
