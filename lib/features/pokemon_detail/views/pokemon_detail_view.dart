import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:pokedex_simplificada_v2/core/di/dependency_injector.dart';
import 'package:pokedex_simplificada_v2/core/widgets/command_builder.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_detail/data/models/pokemon_detail_model.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_detail/viewmodels/pokemon_detail_viewmodel.dart';

class PokemonDetailView extends StatefulWidget {
  final int id;

  const PokemonDetailView({super.key, required this.id});

  @override
  State<PokemonDetailView> createState() => _PokemonDetailViewState();
}

class _PokemonDetailViewState extends State<PokemonDetailView> {
  late PokemonDetailViewmodel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<PokemonDetailViewmodel>(param1: widget.id);
    _viewModel.fetchPokemonDetailCommand.execute();
  }

  @override
  void didUpdateWidget(covariant PokemonDetailView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.id != widget.id) {
      _viewModel = getIt<PokemonDetailViewmodel>(param1: widget.id);
      _viewModel.fetchPokemonDetailCommand.execute();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 900;
    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          header: true,
          label: 'Detalhes do Pokémon número ${widget.id}',
          child: Text('Pokémon #${widget.id}'),
        ),
        leading: Semantics(
          button: true,
          label: 'Voltar para a lista',
          child: IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            tooltip: 'Voltar',
            onPressed: () {
              context.go('/list');
            },
          ),
        ),
      ),
      body: CommandBuilder<PokemonDetailModel>(
        command: _viewModel.fetchPokemonDetailCommand,
        idle: Center(
          child: Semantics(
            label: 'Carregando detalhes do pokémon',
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: Lottie.asset(
                    'assets/animations/loading.json',
                    repeat: true,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Carregando detalhes...',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        success: (context, pokemon) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _PokemonDetailContent(
            key: ValueKey(pokemon.id),
            pokemon: pokemon,
            isTablet: isTablet,
          ),
        ),
        error: (context, error) => Center(
          child: Semantics(
            label: 'Erro ao carregar detalhes do pokémon',
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, color: Colors.red[400], size: 48),
                const SizedBox(height: 16),
                Text('Erro: $error'),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tentar novamente'),
                  onPressed: _viewModel.fetchPokemonDetailCommand.execute,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PokemonDetailContent extends StatefulWidget {
  final PokemonDetailModel pokemon;
  final bool isTablet;
  const _PokemonDetailContent({
    Key? key,
    required this.pokemon,
    this.isTablet = false,
  }) : super(key: key);

  @override
  State<_PokemonDetailContent> createState() => _PokemonDetailContentState();
}

class _PokemonDetailContentState extends State<_PokemonDetailContent> {
  bool showShiny = false;

  @override
  Widget build(BuildContext context) {
    final shinyUrl = widget.pokemon.sprites.shinyUrl;
    final normalUrl = widget.pokemon.sprites.imageUrl;
    final showShinyAvailable = shinyUrl.isNotEmpty;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = widget.isTablet || constraints.maxWidth > 900;
        final content = SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isWide ? 64 : 8,
            vertical: 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'pokemon-img-${widget.pokemon.id}',
                    child: Semantics(
                      label: 'Imagem do pokémon ${widget.pokemon.name}',
                      child: SizedBox(
                        width: isWide ? 260 : 200,
                        height: isWide ? 260 : 200,
                        child: CachedNetworkImage(
                          imageUrl: showShiny && showShinyAvailable
                              ? shinyUrl
                              : normalUrl,
                          fit: BoxFit.contain,
                          placeholder: (context, url) => SizedBox(
                            width: 48,
                            height: 48,
                            child: Lottie.asset(
                              'assets/animations/lottie/loading.json',
                              repeat: true,
                            ),
                          ),
                          errorWidget: (context, url, error) => Icon(
                            Icons.catching_pokemon,
                            size: isWide ? 160 : 120,
                            color: showShiny ? Colors.amber : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Hero(
                tag: 'pokemon-name-${widget.pokemon.id}',
                child: Material(
                  color: Colors.transparent,
                  child: Semantics(
                    header: true,
                    label: 'Nome do pokémon: ${widget.pokemon.name}',
                    child: Text(
                      widget.pokemon.name[0].toUpperCase() +
                          widget.pokemon.name.substring(1),
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Semantics(
                    button: true,
                    label: 'Ver pokémon anterior',
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      tooltip: 'Anterior',
                      onPressed: widget.pokemon.id > 1
                          ? () =>
                                context.go('/pokemon/${widget.pokemon.id - 1}')
                          : null,
                    ),
                  ),
                  Semantics(
                    button: true,
                    label: 'Ver próximo pokémon',
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward_rounded),
                      tooltip: 'Próximo',
                      onPressed: () =>
                          context.go('/pokemon/${widget.pokemon.id + 1}'),
                    ),
                  ),
                ],
              ),
              if (showShinyAvailable)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Semantics(
                    button: true,
                    label: showShiny
                        ? 'Exibir sprite normal'
                        : 'Exibir sprite shiny',
                    child: ElevatedButton.icon(
                      icon: Icon(
                        showShiny
                            ? Icons.catching_pokemon
                            : Icons.catching_pokemon_outlined,
                        color: Colors.redAccent,
                      ),
                      label: Text(
                        showShiny ? 'Shiny' : 'Normal',
                        style: const TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        setState(() {
                          showShiny = !showShiny;
                        });
                      },
                    ),
                  ),
                ),
              Text(
                '#${widget.pokemon.id.toString().padLeft(3, '0')}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: widget.pokemon.types.map((typeSlot) {
                  final isDark =
                      Theme.of(context).brightness == Brightness.dark;
                  return Semantics(
                    label: 'Tipo ${typeSlot.type.name}',
                    child: Chip(
                      label: Text(
                        typeSlot.type.name.toUpperCase(),
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: _getTypeColor(
                        typeSlot.type.name,
                      ).withOpacity(isDark ? 0.4 : 0.2),
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: _getTypeColor(
                            typeSlot.type.name,
                          ).withOpacity(isDark ? 0.7 : 1.0),
                          width: 1.2,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _InfoCard(
                    label: 'Altura',
                    value: '${widget.pokemon.height / 10} m',
                  ),
                  _InfoCard(
                    label: 'Peso',
                    value: '${widget.pokemon.weight / 10} kg',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('Stats', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              ...widget.pokemon.stats.map(
                (statSlot) => TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 600),
                  tween: Tween(begin: 0, end: statSlot.baseStat.toDouble()),
                  builder: (context, value, child) => _StatBar(
                    name: statSlot.stat.name,
                    value: value.toInt(),
                    color: _getStatColor(statSlot.baseStat),
                  ),
                ),
              ),
            ],
          ),
        );
        return content;
      },
    );
  }
}

Color _getTypeColor(String type) {
  const typeColors = {
    'normal': Colors.brown,
    'fire': Colors.red,
    'water': Colors.blue,
    'electric': Colors.yellow,
    'grass': Colors.green,
    'ice': Colors.cyan,
    'fighting': Colors.orange,
    'poison': Colors.purple,
    'ground': Colors.brown,
    'flying': Colors.indigo,
    'psychic': Colors.pink,
    'bug': Colors.lightGreen,
    'rock': Colors.grey,
    'ghost': Colors.deepPurple,
    'dragon': Colors.indigoAccent,
    'dark': Colors.black54,
    'steel': Colors.blueGrey,
    'fairy': Colors.pinkAccent,
  };
  return typeColors[type] ?? Colors.grey;
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;

  const _InfoCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            Text(value, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}

class _StatBar extends StatelessWidget {
  final String name;
  final int value;
  final Color? color;

  const _StatBar({required this.name, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(name.replaceAll('-', '').toUpperCase()),
          ),
          SizedBox(width: 40, child: Text('$value')),
          Expanded(
            child: LinearProgressIndicator(
              value: value / 255,
              backgroundColor: Colors.grey[300],
              color: color ?? Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

Color _getStatColor(int value) {
  if (value >= 120) return Colors.green;
  if (value >= 80) return Colors.orange;
  return Colors.red;
}
