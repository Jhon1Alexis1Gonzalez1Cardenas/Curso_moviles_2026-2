import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/api_endpoint.dart';
import '../routes/app_router.dart';
import '../widgets/dashboard_card.dart';

/// Home: una card por cada endpoint. Al tocarla se navega a su listado.
class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Datos Abiertos de Colombia')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 12),
            child: Text(
              'Explora la información pública de API Colombia. '
              'Elige una categoría:',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          for (final endpoint in ApiEndpoint.values)
            DashboardCard(
              endpoint: endpoint,
              onTap: () => context.pushNamed(
                AppRoutes.listado,
                pathParameters: {'tipo': endpoint.name},
              ),
            ),
        ],
      ),
    );
  }
}
