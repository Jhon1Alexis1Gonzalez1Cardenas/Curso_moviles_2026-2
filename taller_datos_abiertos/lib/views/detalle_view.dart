import 'package:flutter/material.dart';

import '../config/api_endpoint.dart';
import '../models/estado_carga.dart';
import '../models/item_api.dart';
import '../services/api_colombia_service.dart';
import '../widgets/estado_widgets.dart';
import '../widgets/safe_network_image.dart';

/// Detalle de un registro. Recibe por la ruta el tipo y el id, y consulta
/// GET /{endpoint}/{id}. El título que llega en `extra` solo se usa en el
/// AppBar mientras carga.
class DetalleView extends StatefulWidget {
  const DetalleView({
    super.key,
    required this.endpoint,
    required this.id,
    this.tituloInicial,
  });

  final ApiEndpoint endpoint;
  final int id;
  final String? tituloInicial;

  @override
  State<DetalleView> createState() => _DetalleViewState();
}

class _DetalleViewState extends State<DetalleView> {
  final ApiColombiaService _service = ApiColombiaService();

  Estado _estado = Estado.cargando;
  ItemApi? _item;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _estado = Estado.cargando);
    try {
      final item = await _service.obtenerPorId(widget.endpoint, widget.id);
      if (!mounted) return;
      setState(() {
        _item = item;
        _estado = Estado.exito;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.mensaje;
        _estado = Estado.error;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Ocurrió un error inesperado.';
        _estado = Estado.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final titulo = _item?.titulo ?? widget.tituloInicial ?? widget.endpoint.titulo;
    return Scaffold(
      appBar: AppBar(title: Text(titulo, overflow: TextOverflow.ellipsis)),
      body: switch (_estado) {
        Estado.cargando => const CargandoView(mensaje: 'Cargando detalle...'),
        Estado.error => ErrorView(mensaje: _error, onReintentar: _cargar),
        Estado.exito => _contenido(_item!),
      },
    );
  }

  Widget _contenido(ItemApi item) {
    final tema = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.imagen != null)
            SafeNetworkImage(
              url: item.imagen,
              width: double.infinity,
              height: 220,
              icono: widget.endpoint.icono,
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.titulo, style: tema.textTheme.headlineSmall),
                if (item.subtitulo != null) ...[
                  const SizedBox(height: 8),
                  Chip(
                    avatar: Icon(widget.endpoint.icono, size: 18),
                    label: Text(item.subtitulo!),
                  ),
                ],
                const SizedBox(height: 16),
                Text(
                  item.descripcion.isEmpty ? 'Sin descripción disponible.' : item.descripcion,
                  style: tema.textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                Text('Datos clave', style: tema.textTheme.titleMedium),
                const SizedBox(height: 8),
                Card(
                  child: Column(
                    children: [
                      for (final entrada in item.datos.entries)
                        ListTile(
                          dense: true,
                          title: Text(entrada.key),
                          subtitle: Text(entrada.value),
                        ),
                    ],
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
