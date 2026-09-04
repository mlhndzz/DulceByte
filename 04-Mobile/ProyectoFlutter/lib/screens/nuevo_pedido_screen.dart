import 'package:flutter/material.dart';

import '../models/cliente.dart';
import '../models/pedido.dart';
import '../models/producto.dart';
import '../services/pedido_service.dart';
import '../services/producto_service.dart';

class NuevoPedidoScreen extends StatefulWidget {
  const NuevoPedidoScreen({super.key});

  @override
  State<NuevoPedidoScreen> createState() => _NuevoPedidoScreenState();
}

class _NuevoPedidoScreenState extends State<NuevoPedidoScreen> {
  final PedidoService _pedidoService = PedidoService();
  final ProductoService _productoService = ProductoService();
  final TextEditingController _cantidadController = TextEditingController(text: '1');

  List<Cliente> _clientes = const [];
  List<Producto> _productos = const [];
  int? _idCliente;
  int? _idProducto;
  bool _cargandoDatos = true;
  bool _guardando = false;
  bool _agregandoProducto = false;
  String? _error;
  String? _errorDetalle;
  Pedido? _pedidoCreado;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  @override
  void dispose() {
    _cantidadController.dispose();
    super.dispose();
  }

  Future<void> _cargarDatos() async {
    setState(() {
      _cargandoDatos = true;
      _error = null;
    });

    try {
      final resultados = await Future.wait([
        _pedidoService.listarClientes(),
        _productoService.listar(),
      ]);

      if (!mounted) return;

      final clientes = resultados[0] as List<Cliente>;
      final productos = resultados[1] as List<Producto>;

      setState(() {
        _clientes = clientes;
        _productos = productos.where((producto) => producto.disponible).toList();
        _cargandoDatos = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = _cleanError(error);
        _cargandoDatos = false;
      });
    }
  }

  Future<void> _crearPedido() async {
    final idCliente = _idCliente;
    if (idCliente == null || _guardando) return;

    setState(() {
      _guardando = true;
      _error = null;
      _errorDetalle = null;
      _pedidoCreado = null;
      _idProducto = null;
      _cantidadController.text = '1';
    });

    try {
      final pedido = await _pedidoService.crearPedido(idCliente);
      if (!mounted) return;
      setState(() {
        _pedidoCreado = pedido;
        _guardando = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pedido creado correctamente.')),
      );
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = _cleanError(error);
        _guardando = false;
      });
    }
  }

  Future<void> _agregarProducto() async {
    final pedido = _pedidoCreado;
    final idProducto = _idProducto;
    final cantidad = int.tryParse(_cantidadController.text.trim());

    if (pedido == null || idProducto == null || _agregandoProducto) return;

    if (cantidad == null || cantidad < 1 || cantidad > 100) {
      setState(() {
        _errorDetalle = 'La cantidad debe estar entre 1 y 100.';
      });
      return;
    }

    setState(() {
      _agregandoProducto = true;
      _errorDetalle = null;
    });

    try {
      final actualizado = await _pedidoService.agregarDetalle(
        idPedido: pedido.idPedido,
        idProducto: idProducto,
        cantidad: cantidad,
      );

      if (!mounted) return;

      setState(() {
        _pedidoCreado = actualizado;
        _idProducto = null;
        _cantidadController.text = '1';
        _agregandoProducto = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto agregado al pedido.')),
      );
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorDetalle = _cleanError(error);
        _agregandoProducto = false;
      });
    }
  }

  String _cleanError(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
        children: [
          Text(
            'Nuevo pedido',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: const Color(0xFF5D2A42),
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Selecciona un cliente, crea el pedido y agrega sus productos.',
            style: TextStyle(color: Color(0xFF765865)),
          ),
          const SizedBox(height: 22),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _buildForm(),
            ),
          ),
          if (_pedidoCreado != null) ...[
            const SizedBox(height: 18),
            _PedidoCard(pedido: _pedidoCreado!),
            const SizedBox(height: 18),
            _buildAgregarProductoCard(),
          ],
        ],
      ),
    );
  }

  Widget _buildForm() {
    if (_cargandoDatos) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 28),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null && _clientes.isEmpty) {
      return Column(
        children: [
          const Icon(
            Icons.cloud_off_outlined,
            size: 48,
            color: Color(0xFF5D2A42),
          ),
          const SizedBox(height: 12),
          Text(
            _error!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF765865)),
          ),
          const SizedBox(height: 16),
          FilledButton.tonal(
            onPressed: _cargarDatos,
            child: const Text('Reintentar'),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cliente',
          style: TextStyle(
            color: Color(0xFF5D2A42),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          initialValue: _idCliente,
          decoration: const InputDecoration(
            hintText: 'Seleccione un cliente',
          ),
          items: _clientes
              .map(
                (cliente) => DropdownMenuItem<int>(
                  value: cliente.idCliente,
                  child: Text(cliente.nombre),
                ),
              )
              .toList(),
          onChanged: _guardando
              ? null
              : (value) {
                  setState(() {
                    _idCliente = value;
                    _pedidoCreado = null;
                    _error = null;
                  });
                },
        ),
        if (_error != null) ...[
          const SizedBox(height: 14),
          Text(
            _error!,
            style: const TextStyle(color: Color(0xFFA3314E)),
          ),
        ],
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _idCliente == null || _guardando ? null : _crearPedido,
            child: _guardando
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : const Text('Crear pedido'),
          ),
        ),
      ],
    );
  }

  Widget _buildAgregarProductoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Agregar producto',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF5D2A42),
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              initialValue: _idProducto,
              decoration: const InputDecoration(
                labelText: 'Producto',
                hintText: 'Seleccione un producto',
                ),
              items: _productos
                  .map(
                    (producto) => DropdownMenuItem<int>(
                      value: producto.idProducto,
                      child: Text('${producto.nombre} - \$${producto.precio.toStringAsFixed(2)}'),
                    ),
                  )
                  .toList(),
              onChanged: _agregandoProducto
                  ? null
                  : (value) {
                      setState(() {
                        _idProducto = value;
                        _errorDetalle = null;
                      });
                    },
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _cantidadController,
              enabled: !_agregandoProducto,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Cantidad',
              ),
            ),
            if (_errorDetalle != null) ...[
              const SizedBox(height: 12),
              Text(
                _errorDetalle!,
                style: const TextStyle(color: Color(0xFFA3314E)),
              ),
            ],
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _idProducto == null || _agregandoProducto
                    ? null
                    : _agregarProducto,
                child: _agregandoProducto
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Agregar al pedido'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PedidoCard extends StatelessWidget {
  final Pedido pedido;

  const _PedidoCard({required this.pedido});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFDCCC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFCB1A6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.check_circle_outline, color: Color(0xFF5D2A42)),
              SizedBox(width: 10),
              Text(
                'Pedido registrado',
                style: TextStyle(
                  color: Color(0xFF5D2A42),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _InfoRow(label: 'Pedido', value: '#${pedido.idPedido}'),
          _InfoRow(label: 'Cliente', value: pedido.cliente),
          _InfoRow(label: 'Estado', value: pedido.estado),
          _InfoRow(label: 'Total', value: '\$${pedido.total.toStringAsFixed(2)}'),
          if (pedido.detalles.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(color: Color(0xFFFCB1A6)),
            const SizedBox(height: 8),
            const Text(
              'Productos',
              style: TextStyle(
                color: Color(0xFF5D2A42),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            ...pedido.detalles.map(
              (detalle) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        '${detalle.cantidad} x ${detalle.producto}',
                        style: const TextStyle(
                          color: Color(0xFF5D2A42),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '\$${detalle.subtotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Color(0xFF5D2A42),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 78,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF765865),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF5D2A42),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
