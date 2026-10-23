import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/api_endpoint.dart';
import '../models/estado_carga.dart';
import '../models/item_api.dart';
import '../routes/app_router.dart';
import '../services/api_colombia_service.dart';
import '../widgets/estado_widgets.dart';
import '../widgets/item_card.dart';

/// Listado de un endpoint con estados Cargando / Éxito / Error.
class ListadoView extends StatefulWidget {
  const ListadoView({super.key, required this.endpoint});

  final ApiEndpoint endpoint;

  @override
  State<ListadoView> createState() => _ListadoViewState();
}

class _ListadoViewState extends State<ListadoView> {
  final ApiColombiaService _service = ApiColombiaService();

  Estado _estado = Estado.cargando;
  List<ItemApi> _items = [];
  String _error = '';
  String _filtro = '';

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _estado = Estado.cargando);
    try {
      final datos = await _service.obtenerLista(widget.endpoint);
      if (!mounted) return;
      setState(() {
        _items = datos;
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

  List<ItemApi> get _filtrados {
    final q = _filtro.trim().toLowerCase();
    if (q.isEmpty) return _items;
    return _items.where((i) => i.titulo.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.endpoint.titulo)),
      body: switch (_estado) {
        Estado.cargando => const CargandoView(mensaje: 'Consultando API Colombia...'),
        Estado.error => ErrorView(mensaje: _error, onReintentar: _cargar),
        Estado.exito => _contenido(),
      },
    );
  }

  Widget _contenido() {
    final lista = _filtrados;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Buscar en ${widget.endpoint.titulo.toLowerCase()}...',
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (valor) => setState(() => _filtro = valor),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('${lista.length} resultados',
                style: Theme.of(context).textTheme.labelMedium),
          ),
        ),
        Expanded(
          child: lista.isEmpty
              ? const Center(child: Text('Sin resultados para tu búsqueda.'))
              : ListView.builder(
                  itemCount: lista.length,
                  itemBuilder: (context, index) {
                    final item = lista[index];
                    return ItemCard(
                      item: item,
                      icono: widget.endpoint.icono,
                      onTap: () => context.pushNamed(
                        AppRoutes.detalle,
                        pathParameters: {
                          'tipo': widget.endpoint.name,
                          'id': item.id.toString(),
                        },
                        extra: item.titulo,
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
