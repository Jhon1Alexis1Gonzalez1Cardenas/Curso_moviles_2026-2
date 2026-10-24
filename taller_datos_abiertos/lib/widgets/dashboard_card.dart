import 'package:flutter/material.dart';

import '../config/api_endpoint.dart';

/// Card del Dashboard que presenta un endpoint y navega a su listado.
class DashboardCard extends StatelessWidget {
  const DashboardCard({super.key, required this.endpoint, required this.onTap});

  final ApiEndpoint endpoint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: tema.colorScheme.primaryContainer,
                child: Icon(endpoint.icono, size: 28, color: tema.colorScheme.onPrimaryContainer),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(endpoint.titulo, style: tema.textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(endpoint.descripcion, style: tema.textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    Text(
                      'GET /${endpoint.path}',
                      style: tema.textTheme.labelSmall?.copyWith(
                        fontFamily: 'monospace',
                        color: tema.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
