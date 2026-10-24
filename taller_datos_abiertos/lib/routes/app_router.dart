import 'package:go_router/go_router.dart';

import '../config/api_endpoint.dart';
import '../views/dashboard_view.dart';
import '../views/detalle_view.dart';
import '../views/listado_view.dart';
import '../views/ruta_invalida_view.dart';

/// Nombres de las rutas (se usan con pushNamed / goNamed).
class AppRoutes {
  static const String dashboard = 'dashboard';
  static const String listado = 'listado';
  static const String detalle = 'detalle';
}

/// Configuración de go_router.
///
///   /                                     -> Dashboard
///   /listado/:tipo                        -> Listado (tipo = departamentos, ...)
///   /listado/:tipo/detalle/:id            -> Detalle (extra = título del registro)
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) => const RutaInvalidaView(),
  routes: [
    GoRoute(
      path: '/',
      name: AppRoutes.dashboard,
      builder: (context, state) => const DashboardView(),
      routes: [
        GoRoute(
          path: 'listado/:tipo',
          name: AppRoutes.listado,
          builder: (context, state) {
            final endpoint = ApiEndpoint.desdeNombre(state.pathParameters['tipo']);
            if (endpoint == null) return const RutaInvalidaView();
            return ListadoView(endpoint: endpoint);
          },
          routes: [
            GoRoute(
              path: 'detalle/:id',
              name: AppRoutes.detalle,
              builder: (context, state) {
                final endpoint = ApiEndpoint.desdeNombre(state.pathParameters['tipo']);
                final id = int.tryParse(state.pathParameters['id'] ?? '');
                if (endpoint == null || id == null) return const RutaInvalidaView();
                return DetalleView(
                  endpoint: endpoint,
                  id: id,
                  tituloInicial: state.extra is String ? state.extra as String : null,
                );
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
