class Cliente {
  final int idCliente;
  final String nombre;
  final String telefono;
  final String correo;

  const Cliente({
    required this.idCliente,
    required this.nombre,
    required this.telefono,
    required this.correo,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      idCliente: _asInt(json['idCliente']),
      nombre: json['nombre']?.toString() ?? '',
      telefono: json['telefono']?.toString() ?? '',
      correo: json['correo']?.toString() ?? '',
    );
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
