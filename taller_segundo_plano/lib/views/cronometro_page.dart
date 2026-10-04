import 'dart:async';
import 'dart:ui' show FontFeature;
import 'package:flutter/material.dart';

class CronometroPage extends StatefulWidget {
  const CronometroPage({super.key});

  @override
  State<CronometroPage> createState() => _CronometroPageState();
}

class _CronometroPageState extends State<CronometroPage> {
  final Stopwatch _sw = Stopwatch();
  Timer? _timer;
  bool _iniciado = false;

  bool get _corriendo => _timer?.isActive ?? false;

  void _iniciar() {
    _sw.start();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      setState(() {}); // refresca la UI con _sw.elapsed
    });
    setState(() => _iniciado = true);
  }

  void _pausar() {
    _timer?.cancel();
    _sw.stop();
    setState(() {});
  }

  void _reanudar() => _iniciar();

  void _reiniciar() {
    _timer?.cancel();
    _sw
      ..stop()
      ..reset();
    setState(() => _iniciado = false);
  }

  @override
  void dispose() {
    _timer?.cancel(); // limpieza de recursos al salir de la vista
    super.dispose();
  }

  String _formato(Duration d) {
    String dos(int n) => n.toString().padLeft(2, '0');
    final decimas = d.inMilliseconds.remainder(1000) ~/ 100;
    return '${dos(d.inMinutes)}:${dos(d.inSeconds.remainder(60))}.$decimas';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _formato(_sw.elapsed),
            style: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.bold,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 12,
            children: [
              if (!_iniciado)
                ElevatedButton(
                    onPressed: _iniciar, child: const Text('Iniciar')),
              if (_iniciado && _corriendo)
                ElevatedButton(
                    onPressed: _pausar, child: const Text('Pausar')),
              if (_iniciado && !_corriendo)
                ElevatedButton(
                    onPressed: _reanudar, child: const Text('Reanudar')),
              OutlinedButton(
                  onPressed: _reiniciar, child: const Text('Reiniciar')),
            ],
          ),
        ],
      ),
    );
  }
}
