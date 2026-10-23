import 'package:flutter/material.dart';

/// Imagen de red tolerante a datos sucios: la API a veces trae textos que no
/// son URL ("null", "") o URLs con espacios. Si algo falla muestra un ícono.
class SafeNetworkImage extends StatelessWidget {
  const SafeNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.icono = Icons.image_not_supported_outlined,
  });

  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final IconData icono;

  bool get _esValida => url != null && url!.trim().toLowerCase().startsWith('http');

  Widget _placeholder(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(icono, color: Theme.of(context).colorScheme.outline),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_esValida) return _placeholder(context);

    // Solo se codifican los espacios: encodeFull duplicaría los '%' ya presentes.
    final direccion = url!.trim().replaceAll(' ', '%20');

    return Image.network(
      direccion,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, progreso) {
        if (progreso == null) return child;
        return SizedBox(
          width: width,
          height: height,
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );
      },
      errorBuilder: (context, error, stack) => _placeholder(context),
    );
  }
}
