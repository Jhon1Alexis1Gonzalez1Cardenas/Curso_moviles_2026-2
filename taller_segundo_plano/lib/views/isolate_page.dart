import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// Número de iteraciones de la tarea pesada. Ajusta según tu equipo.
const int kIteraciones = 300000000;

/// Función CPU-bound (top-level para poder usarla desde un Isolate).
int sumaPesada(int n) {
  int suma = 0;
  for (int i = 1; i <= n; i++) {
    suma += (i % 7) * (i % 13);
  }
  return suma;
}

/// Punto de entrada del Isolate: calcula y devuelve el resultado por mensaje.
void _isolateEntry(List<Object> args) {
  final SendPort sendPort = args[0] as SendPort;
  final int n = args[1] as int;
  debugPrint('[Isolate] Calculando en hilo secundario...');
  final resultado = sumaPesada(n);
  debugPrint('[Isolate] Cálculo terminado, enviando mensaje');
  sendPort.send(resultado);
}

class IsolatePage extends StatefulWidget {
  const IsolatePage({super.key});

  @override
  State<IsolatePage> createState() => _IsolatePageState();
}

class _IsolatePageState extends State<IsolatePage> {
  String _resultado = 'Sin ejecutar';
  String _tiempo = '';
  bool _calculando = false;
  Isolate? _isolate;

  Future<void> _conIsolate() async {
    setState(() {
      _calculando = true;
      _resultado = 'Calculando en Isolate...';
      _tiempo = '';
    });
    debugPrint('[UI] Lanzando Isolate');
    final sw = Stopwatch()..start();

    final receivePort = ReceivePort();
    final errorPort = ReceivePort();
    final completer = Completer<int>();

    receivePort.listen((msg) {
      if (!completer.isCompleted) completer.complete(msg as int);
    });
    errorPort.listen((e) {
      if (!completer.isCompleted) completer.completeError(e.toString());
    });

    try {
      _isolate = await Isolate.spawn(_isolateEntry, <Object>[
        receivePort.sendPort,
        kIteraciones,
      ], onError: errorPort.sendPort);

      final resultado = await completer.future;
      sw.stop();
      debugPrint(
        '[UI] Resultado recibido: $resultado en ${sw.elapsedMilliseconds} ms',
      );

      if (!mounted) return;
      setState(() {
        _resultado = 'Resultado: $resultado';
        _tiempo = 'Tiempo (Isolate): ${sw.elapsedMilliseconds} ms';
      });
    } catch (e) {
      debugPrint('[UI] Error en Isolate: $e');
      if (mounted) setState(() => _resultado = 'Error: $e');
    } finally {
      receivePort.close();
      errorPort.close();
      _isolate?.kill(priority: Isolate.immediate);
      _isolate = null;
      if (mounted) setState(() => _calculando = false);
    }
  }

  Future<void> _sinIsolate() async {
    setState(() {
      _calculando = true;
      _resultado = 'Calculando en el hilo principal (UI congelada)...';
      _tiempo = '';
    });
    await Future.delayed(const Duration(milliseconds: 100)); // deja pintar
    debugPrint('[UI] Calculando SIN Isolate (bloquea la UI)');
    final sw = Stopwatch()..start();
    final resultado = sumaPesada(kIteraciones);
    sw.stop();
    debugPrint('[UI] Terminó SIN Isolate en ${sw.elapsedMilliseconds} ms');
    if (!mounted) return;
    setState(() {
      _calculando = false;
      _resultado = 'Resultado: $resultado';
      _tiempo = 'Tiempo (sin Isolate): ${sw.elapsedMilliseconds} ms';
    });
  }

  @override
  void dispose() {
    _isolate?.kill(priority: Isolate.immediate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Si este spinner se congela, la UI está bloqueada.
            if (_calculando) const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              _resultado,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(_tiempo, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _calculando ? null : _conIsolate,
              child: const Text('Calcular con Isolate'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _calculando ? null : _sinIsolate,
              child: const Text('Calcular SIN Isolate (comparar)'),
            ),
          ],
        ),
      ),
    );
  }
}
