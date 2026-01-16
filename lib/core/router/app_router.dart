import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_compare/views/pokemon_compare_view.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_detail/views/pokemon_detail_view.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_list/views/pokemon_list_view.dart';

final appRouter = GoRouter(
  initialLocation: '/list',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return _MainShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/list',
          name: 'list',
          builder: (context, state) => PokemonListView(),
        ),
        GoRoute(
          path: '/compare',
          name: 'compare',
          builder: (context, state) {
            final pokemon1 = state.uri.queryParameters['pokemon1'] ?? '';
            final pokemon2 = state.uri.queryParameters['pokemon2'] ?? '';
            return PokemonCompareView(pokemon1: pokemon1, pokemon2: pokemon2);
          },
        ),
        GoRoute(
          path: '/pokemon/:id',
          name: 'detail',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id'] ?? '0');
            return PokemonDetailView(id: id);
          },
        ),
      ],
    ),
  ],
);

class _MainShell extends StatelessWidget {
  final Widget child;

  const _MainShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Lista Pokemon',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.compare), label: 'Comparar'),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/list')) return 0;
    if (location.startsWith('/compare')) return 1;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/list');
        break;
      case 1:
        context.go('/compare?pokemon1=charizard&pokemon2=venusaur');
        break;
    }
  }
}
