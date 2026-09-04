import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onOpenProducts;
  final VoidCallback onOpenOrders;

  const HomeScreen({
    super.key,
    required this.onOpenProducts,
    required this.onOpenOrders,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
        children: [
          Text(
            'Panel principal',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: const Color(0xFF5D2A42),
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Consulta productos y registra pedidos desde la aplicación móvil de DulceByte.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF765865),
                  height: 1.4,
                ),
          ),
          const SizedBox(height: 24),
          _QuickAccessCard(
            icon: Icons.inventory_2_outlined,
            title: 'Productos',
            description: 'Consulta el catálogo actualizado directamente desde la API.',
            buttonText: 'Ver productos',
            onPressed: onOpenProducts,
          ),
          const SizedBox(height: 16),
          _QuickAccessCard(
            icon: Icons.receipt_long_outlined,
            title: 'Pedidos',
            description: 'Selecciona un cliente y registra un nuevo pedido.',
            buttonText: 'Crear pedido',
            onPressed: onOpenOrders,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFFFDCCC),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.cloud_done_outlined, color: Color(0xFF5D2A42)),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'La información se consulta y registra mediante la misma API REST utilizada por la aplicación web.',
                    style: TextStyle(
                      color: Color(0xFF5D2A42),
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onPressed;

  const _QuickAccessCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFFCB1A6),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: const Color(0xFF5D2A42)),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: const Color(0xFF5D2A42),
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF765865),
                    height: 1.4,
                  ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onPressed,
                child: Text(buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
