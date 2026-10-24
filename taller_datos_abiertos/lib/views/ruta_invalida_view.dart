import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Pantalla para rutas o parámetros que no existen.
class RutaInvalidaView extends StatelessWidget {
  const RutaInvalidaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Página no encontrada')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.explore_off_outlined, size: 64),
            const SizedBox(height: 16),
            const Text('La ruta solicitada no existe.'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go('/'),
              child: const Text('Volver al inicio'),
            ),
          ],
        ),
      ),
    );
  }
}
