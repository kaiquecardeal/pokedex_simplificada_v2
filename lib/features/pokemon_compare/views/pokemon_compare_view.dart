import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pokedex_simplificada_v2/core/di/dependency_injector.dart';
import 'package:pokedex_simplificada_v2/core/widgets/command_builder.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_compare/viewmodels/pokemon_compare_viewmodel.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_detail/data/models/pokemon_detail_model.dart';

class PokemonCompareView extends StatefulWidget {
  final String pokemon1;
  final String pokemon2;

  const PokemonCompareView({
    super.key,
    required this.pokemon1,
    required this.pokemon2,
  });

  @override
  State<PokemonCompareView> createState() => _PokemonCompareViewState();
}

class _PokemonCompareViewState extends State<PokemonCompareView> {
  late final PokemonCompareViewmodel _viewModel;

  final TextEditingController _pokemon1Controller = TextEditingController();
  final TextEditingController _pokemon2Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<PokemonCompareViewmodel>();
    // Só executa fetch se ambos os parâmetros estiverem preenchidos
    if ((widget.pokemon1.isNotEmpty) && (widget.pokemon2.isNotEmpty)) {
      _viewModel.fetchPokemonsCommand.execute((
        widget.pokemon1,
        widget.pokemon2,
      ));
    }
  }

  void _onComparePressed() {
    // 1. Captura os textos, remove espaços extras e padroniza para minúsculas
    final p1 = _pokemon1Controller.text.trim().toLowerCase();
    final p2 = _pokemon2Controller.text.trim().toLowerCase();

    if (p1.isNotEmpty && p2.isNotEmpty) {
      // 2. Executa o comando passando a nova tupla de nomes
      _viewModel.fetchPokemonsCommand.execute((p1, p2));

      // 3. Atualiza a URL no navegador/app para manter a consistência com a rota
      context.go('/compare?pokemon1=$p1&pokemon2=$p2');
    } else {
      // Feedback visual caso falte algum nome (Responsabilidade Social/UX)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha ambos os nomes.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 900;
    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          header: true,
          label: 'Tela de comparação de pokémons',
          child: const Text('Comparar Pokémons'),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Semantics(
                    textField: true,
                    label: 'Campo para nome do primeiro pokémon',
                    child: TextField(
                      controller: _pokemon1Controller,
                      onSubmitted: (_) => _onComparePressed(),
                      decoration: const InputDecoration(hintText: 'Pokémon 1'),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text('VS'),
                const SizedBox(width: 8),
                Expanded(
                  child: Semantics(
                    textField: true,
                    label: 'Campo para nome do segundo pokémon',
                    child: TextField(
                      controller: _pokemon2Controller,
                      decoration: const InputDecoration(hintText: 'Pokémon 2'),
                    ),
                  ),
                ),
                Semantics(
                  button: true,
                  label: 'Comparar pokémons',
                  child: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: _onComparePressed,
                  ),
                ),
              ],
            ),
          ),
          if (widget.pokemon1.isEmpty || widget.pokemon2.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Semantics(
                  label: 'Preencha ambos os campos para comparar',
                  child: const Text(
                    'Use: /compare',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          if (widget.pokemon1.isNotEmpty && widget.pokemon2.isNotEmpty)
            Expanded(
              child: CommandBuilder<(PokemonDetailModel, PokemonDetailModel)>(
                command: _viewModel.fetchPokemonsCommand,
                idle: Center(
                  child: Semantics(
                    label: 'Carregando dados dos pokémons para comparação',
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: CircularProgressIndicator(),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Carregando pokémons...',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                success: (context, pokemons) => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: _PokemonCompareContent(
                    key: ValueKey('${pokemons.$1.id}-${pokemons.$2.id}'),
                    leftPokemon: pokemons.$1,
                    rightPokemon: pokemons.$2,
                    isTablet: isTablet,
                  ),
                ),
                error: (context, error) => Center(
                  child: Semantics(
                    label: 'Erro ao comparar pokémons',
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
                          onPressed: _onComparePressed,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PokemonCompareContent extends StatelessWidget {
  final PokemonDetailModel leftPokemon;
  final PokemonDetailModel rightPokemon;
  final bool isTablet;

  const _PokemonCompareContent({
    Key? key,
    required this.leftPokemon,
    required this.rightPokemon,
    this.isTablet = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double cardMaxWidth = 340;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: cardMaxWidth),
                    child: _PokemonCompareCard(pokemon: leftPokemon),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: cardMaxWidth * 0.7, // Aproxima altura dos cards
                  child: Icon(
                    Icons.compare_arrows,
                    size: 44,
                    color: Colors.grey[600],
                  ),
                ),
                Flexible(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: cardMaxWidth),
                    child: _PokemonCompareCard(pokemon: rightPokemon),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Divider(
              thickness: 2,
              indent: 24,
              endIndent: 24,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 12),
            Text('Stats', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            ...leftPokemon.stats.asMap().entries.map((entry) {
              final leftStat = entry.value;
              final rightStat = rightPokemon.stats[entry.key];
              return TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 600),
                tween: Tween(begin: 0, end: leftStat.baseStat.toDouble()),
                builder: (context, value, child) => _PokemonStatComparison(
                  statName: leftStat.stat.name,
                  leftValue: value.toInt(),
                  rightValue: rightStat.baseStat,
                ),
              );
            }),
          ],
        ),
      ),
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

class _PokemonCompareCard extends StatelessWidget {
  final PokemonDetailModel pokemon;

  const _PokemonCompareCard({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Semantics(
              label: 'Imagem do pokémon ${pokemon.name}',
              child: CachedNetworkImage(
                imageUrl: pokemon.sprites.imageUrl,
                height: 150,
                placeholder: (context, url) => const SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.catching_pokemon, size: 150),
              ),
            ),
            Semantics(
              header: true,
              label: 'Nome do pokémon: ${pokemon.name}',
              child: Text(
                pokemon.name[0].toUpperCase() + pokemon.name.substring(1),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Text('#${pokemon.id.toString().padLeft(3, '0')}'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              children: pokemon.types.map((typeSlot) {
                final isDark = Theme.of(context).brightness == Brightness.dark;
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
                        width: 1,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _PokemonStatComparison extends StatelessWidget {
  final String statName;
  final int leftValue;
  final int rightValue;

  const _PokemonStatComparison({
    required this.statName,
    required this.leftValue,
    required this.rightValue,
  });

  @override
  Widget build(BuildContext context) {
    final winner = leftValue > rightValue
        ? 1
        : (rightValue > leftValue ? 2 : 0);

    Color getBarColor(int value, bool isWinner) {
      if (isWinner) return Colors.green;
      if (value >= 120) return Colors.orange;
      return Colors.blue;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Text(statName.replaceAll('-', ' ').toUpperCase()),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '$leftValue',
                style: TextStyle(
                  fontWeight: winner == 1 ? FontWeight.bold : FontWeight.normal,
                  color: winner == 1 ? Colors.green : null,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: LinearProgressIndicator(
                  value: leftValue / 255,
                  backgroundColor: Colors.grey[300],
                  color: getBarColor(leftValue, winner == 1),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: LinearProgressIndicator(
                  value: rightValue / 255,
                  backgroundColor: Colors.grey[300],
                  color: getBarColor(rightValue, winner == 2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$rightValue',
                style: TextStyle(
                  fontWeight: winner == 2 ? FontWeight.bold : FontWeight.normal,
                  color: winner == 2 ? Colors.green : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
