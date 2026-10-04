import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/estado_carga.dart';
import '../services/datos_service.dart';

class FuturePage extends StatefulWidget {
  const FuturePage({super.key});

  @override
  State<FuturePage> createState() => _FuturePageState();
}

class _FuturePageState extends State<FuturePage> {
  final _service = DatosService();
  Estado _estado = Estado.inicial;
  String _mensaje = 'Presiona un botón para consultar';

  Future<void> _consultar({required bool fallar}) async {
    debugPrint('1. ANTES: antes de llamar al servicio');
    setState(() {
      _estado = Estado.cargando;
      _mensaje = 'Cargando...';
    });

    try {
      final futuro = _service.consultarDatos(fallar: fallar);
      debugPrint('2. DURANTE: la UI sigue libre mientras se espera');
      final resultado = await futuro;
      if (!mounted) return;
      setState(() {
        _estado = Estado.exito;
        _mensaje = resultado;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _estado = Estado.error;
        _mensaje = e.toString();
      });
    }
    debugPrint('3. DESPUÉS: la consulta terminó, estado = $_estado');
  }

  @override
  Widget build(BuildContext context) {
    final color = switch (_estado) {
      Estado.exito => Colors.green,
      Estado.error => Colors.red,
      Estado.cargando => Colors.orange,
      Estado.inicial => Colors.grey,
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_estado == Estado.cargando)
              const CircularProgressIndicator()
            else
              Icon(
                _estado == Estado.exito
                    ? Icons.check_circle
                    : _estado == Estado.error
                        ? Icons.error
                        : Icons.cloud_queue,
                size: 80,
                color: color,
              ),
            const SizedBox(height: 16),
            Text(
              _mensaje,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: color),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _estado == Estado.cargando
                  ? null
                  : () => _consultar(fallar: false),
              child: const Text('Consultar (éxito)'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _estado == Estado.cargando
                  ? null
                  : () => _consultar(fallar: true),
              child: const Text('Consultar (error)'),
            ),
          ],
        ),
      ),
    );
  }
}
