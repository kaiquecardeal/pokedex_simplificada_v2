import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:pokedex_simplificada_v2/core/di/dependency_injector.dart';
import 'package:pokedex_simplificada_v2/core/widgets/command_builder.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_list/data/models/pokemon_list_item_model.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_list/viewmodels/pokemon_list_viewmodel.dart';
import 'package:pokedex_simplificada_v2/main.dart';
import 'package:result_command/result_command.dart';

class PokemonListView extends StatefulWidget {
  const PokemonListView({super.key});

  @override
  State<PokemonListView> createState() => _PokemonListViewState();
}

class _PokemonListViewState extends State<PokemonListView> {
  bool _showBackToTop = false;
  late final PokemonListViewmodel _viewModel;
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  String _searchText = '';
  Timer? _debounce;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _suggestionsOverlay;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<PokemonListViewmodel>();
    _viewModel.fetchPokemonsCommand.execute();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
    _onSearchChanged();
    _removeSuggestions();
    if (_searchController.text.isNotEmpty && FocusScope.of(context).hasFocus) {
      _showSuggestions();
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _searchText = _searchController.text.trim().toLowerCase();
      });
      _viewModel.searchPokemonsCommand.execute(_searchText);
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (_viewModel.hasMore &&
          _viewModel.fetchPokemonsCommand.value is! RunningCommand) {
        _viewModel.fetchPokemonsCommand.execute();
      }
    }
    final shouldShow = _scrollController.position.pixels > 200;
    if (_showBackToTop != shouldShow) {
      setState(() {
        _showBackToTop = shouldShow;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    _removeSuggestions();
    super.dispose();
  }

  List<String> get _allPokemonNames =>
      _viewModel.pokemons.map((p) => p.name).toList();

  List<String> _getSuggestions(String query) {
    if (query.isEmpty) return [];
    return _allPokemonNames
        .where((name) => name.toLowerCase().startsWith(query.toLowerCase()))
        .take(8)
        .toList();
  }

  void _showSuggestions() {
    _removeSuggestions();
    final suggestions = _getSuggestions(_searchController.text);
    if (suggestions.isEmpty) return;
    final renderBox = context.findRenderObject() as RenderBox?;
    final size = renderBox?.size ?? Size.zero;
    final overlay = Overlay.of(context);
    _suggestionsOverlay = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width - 32,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(16, 56),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).cardColor,
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: suggestions
                  .map(
                    (name) => ListTile(
                      title: Text(
                        name[0].toUpperCase() + name.substring(1),
                        style: const TextStyle(fontSize: 16),
                      ),
                      onTap: () {
                        _searchController.text = name;
                        _searchController.selection =
                            TextSelection.fromPosition(
                              TextPosition(offset: name.length),
                            );
                        setState(() {
                          _searchText = name.toLowerCase();
                        });
                        _viewModel.searchPokemonsCommand.execute(name);
                        _removeSuggestions();
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
    overlay.insert(_suggestionsOverlay!);
  }

  void _removeSuggestions() {
    _suggestionsOverlay?.remove();
    _suggestionsOverlay = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              label: 'Ícone da Pokedex',
              child: Image.asset(
                'assets/images/icon.png',
                height: 40,
                width: 40,
              ),
            ),
            const SizedBox(width: 8),
            Semantics(
              header: true,
              label: 'Título da aplicação: Pokedex v2',
              child: const Text('Pokedex v2'),
            ),
          ],
        ),
        actions: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeModeNotifier,
            builder: (context, themeMode, _) {
              return Semantics(
                button: true,
                label: themeMode == ThemeMode.dark
                    ? 'Ativar modo claro'
                    : 'Ativar modo escuro',
                child: IconButton(
                  icon: Icon(
                    themeMode == ThemeMode.dark
                        ? Icons.light_mode
                        : Icons.dark_mode,
                  ),
                  tooltip: 'Alternar tema',
                  onPressed: () {
                    themeModeNotifier.value =
                        themeModeNotifier.value == ThemeMode.dark
                        ? ThemeMode.light
                        : ThemeMode.dark;
                  },
                ),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: CompositedTransformTarget(
              link: _layerLink,
              child: Semantics(
                textField: true,
                label: 'Campo de busca de pokémons',
                hint: 'Digite o nome ou tipo do pokémon',
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar Pokémon por nome ou tipo',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  ),
                  onChanged: (_) {
                    _removeSuggestions();
                    if (_searchController.text.isNotEmpty &&
                        FocusScope.of(context).hasFocus) {
                      _showSuggestions();
                    }
                  },
                  onTap: () {
                    if (_searchController.text.isNotEmpty) {
                      _showSuggestions();
                    }
                  },
                  onEditingComplete: _removeSuggestions,
                ),
              ),
            ),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = MediaQuery.of(context).size.width > 900;
          return Stack(
            children: [
              StreamBuilder<List<PokemonListItemModel>>(
                stream: _viewModel.pokemonsStream,
                initialData: _viewModel.pokemons,
                builder: (context, snapshot) {
                  final pokemons = _searchText.isEmpty
                      ? (snapshot.data ?? [])
                      : (snapshot.data ?? []).where((p) {
                          final nameMatch = p.name.toLowerCase().contains(
                            _searchText,
                          );
                          final typeMatch = p.types.any(
                            (type) => type.toLowerCase().contains(_searchText),
                          );
                          return nameMatch || typeMatch;
                        }).toList();
                  final isLoading =
                      _viewModel.fetchPokemonsCommand.value is RunningCommand;
                  return _buildList(
                    pokemons,
                    isTablet: isTablet,
                    isLoading: isLoading,
                  );
                },
              ),
              Positioned.fill(
                child: IgnorePointer(
                  ignoring: true,
                  child: CommandBuilder(
                    command: _viewModel.fetchPokemonsCommand,
                    idle: const SizedBox.shrink(),
                    loading: const SizedBox.shrink(),
                    success: (context, _) => const SizedBox.shrink(),
                    error: (context, error) => Center(
                      child: SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight * 0.7,
                          ),
                          child: Semantics(
                            label: 'Erro ao carregar lista de pokémons',
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error,
                                  color: Colors.red[400],
                                  size: 48,
                                ),
                                const SizedBox(height: 16),
                                Text('Erro: $error'),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Tentar novamente'),
                                  onPressed:
                                      _viewModel.fetchPokemonsCommand.execute,
                                ),
                                Lottie.asset(
                                  'assets/animations/error.json',
                                  height: 120,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (_showBackToTop)
                Positioned(
                  bottom: 24,
                  right: 24,
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    heroTag: 'backToTop',
                    onPressed: () {
                      _scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                      );
                    },
                    tooltip: 'Voltar ao topo',
                    child: const Icon(Icons.arrow_upward),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildList(
    List<PokemonListItemModel> pokemons, {
    bool isTablet = false,
    bool isLoading = false,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = isTablet || constraints.maxWidth > 600;
        if (pokemons.isEmpty) {
          if (isLoading) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    'assets/animations/lottie/loading.json',
                    height: 120,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Carregando pokémons...',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Semantics(
                label: 'Nenhum pokémon encontrado',
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhum Pokémon encontrado.',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        final showLoadMoreLoader =
            _viewModel.hasMore && _searchText.isEmpty && pokemons.isNotEmpty;
        final itemCount = pokemons.length + (showLoadMoreLoader ? 1 : 0);
        if (isWide) {
          // Grid para telas largas
          return GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: constraints.maxWidth ~/ 320,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 2.2,
            ),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              if (index >= pokemons.length) {
                if (showLoadMoreLoader) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }
              final pokemon = pokemons[index];
              return TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 400),
                tween: Tween(begin: 0, end: 1),
                builder: (context, value, child) => Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, (1 - value) * 20),
                    child: child,
                  ),
                ),
                child: _PokemonListTile(
                  pokemon: pokemon,
                  onTap: () {
                    context.go('/pokemon/${pokemon.id}');
                  },
                ),
              );
            },
          );
        } else {
          // Lista para telas pequenas
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: itemCount,
              itemBuilder: (context, index) {
                if (index >= pokemons.length) {
                  if (showLoadMoreLoader) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return const SizedBox.shrink();
                }
                final pokemon = pokemons[index];
                return TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 400),
                  tween: Tween(begin: 0, end: 1),
                  builder: (context, value, child) => Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, (1 - value) * 20),
                      child: child,
                    ),
                  ),
                  child: _PokemonListTile(
                    pokemon: pokemon,
                    onTap: () {
                      context.go('/pokemon/${pokemon.id}');
                    },
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}

class _PokemonListTile extends StatelessWidget {
  final PokemonListItemModel pokemon;
  final VoidCallback onTap;

  const _PokemonListTile({required this.pokemon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Semantics(
        button: true,
        label: 'Detalhes do pokémon ${pokemon.name}',
        hint: 'Toque para ver detalhes do pokémon ${pokemon.name}',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            splashColor: Theme.of(
              context,
            ).colorScheme.primary.withOpacity(0.15),
            highlightColor: Theme.of(
              context,
            ).colorScheme.primary.withOpacity(0.08),
            onTap: onTap,
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'pokemon-img-${pokemon.id}',
                      child: Semantics(
                        label: 'Imagem do pokémon ${pokemon.name}',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: pokemon.imageUrl,
                            width: 64,
                            height: 64,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => SizedBox(
                              width: 20,
                              height: 20,
                              child: Lottie.asset(
                                'assets/animations/lottie/loading.json',
                                width: 20,
                                height: 20,
                                fit: BoxFit.contain,
                                repeat: true,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.catching_pokemon, size: 48),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '#${pokemon.id.toString().padLeft(3, '0')}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Hero(
                            tag: 'pokemon-name-${pokemon.id}',
                            child: Material(
                              color: Colors.transparent,
                              child: Semantics(
                                header: true,
                                label: 'Nome do pokémon: ${pokemon.name}',
                                child: Text(
                                  pokemon.name[0].toUpperCase() +
                                      pokemon.name.substring(1),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            children: pokemon.types
                                .map((type) => _TypeChip(type: type))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String type;
  const _TypeChip({required this.type});

  Color _typeColor(String type) {
    switch (type.toLowerCase()) {
      case 'fire':
        return Colors.deepOrangeAccent;
      case 'water':
        return Colors.blueAccent;
      case 'grass':
        return Colors.green;
      case 'electric':
        return Colors.amber;
      case 'bug':
        return Colors.lightGreen;
      case 'poison':
        return Colors.purple;
      case 'flying':
        return Colors.indigoAccent;
      case 'ground':
        return Colors.brown;
      case 'rock':
        return Colors.grey;
      case 'psychic':
        return Colors.pinkAccent;
      case 'ice':
        return Colors.cyan;
      case 'dragon':
        return Colors.indigo;
      case 'dark':
        return Colors.black54;
      case 'fairy':
        return Colors.pink;
      case 'fighting':
        return Colors.redAccent;
      case 'ghost':
        return Colors.deepPurple;
      case 'steel':
        return Colors.blueGrey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        type[0].toUpperCase() + type.substring(1),
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: _typeColor(type),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      visualDensity: VisualDensity.compact,
    );
  }
}
