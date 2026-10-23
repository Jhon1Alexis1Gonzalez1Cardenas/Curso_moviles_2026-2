import 'package:flutter/material.dart';

import '../models/item_api.dart';
import 'safe_network_image.dart';

/// Fila del listado: miniatura, título y subtítulo del registro.
class ItemCard extends StatelessWidget {
  const ItemCard({super.key, required this.item, required this.icono, required this.onTap});

  final ItemApi item;
  final IconData icono;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SafeNetworkImage(url: item.imagen, width: 56, height: 56, icono: icono),
        ),
        title: Text(item.titulo, maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: item.subtitulo == null
            ? null
            : Text(item.subtitulo!, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
