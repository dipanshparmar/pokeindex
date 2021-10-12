import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// providers
import '../providers/providers.dart';

// models
import '../models/models.dart';

// utils
import '../utils/utils.dart';

// pages
import './pages.dart';

// widgets
import '../widgets/widgets.dart';

class AllMovesPage extends StatelessWidget {
  const AllMovesPage(this.pokemon, {Key? key}) : super(key: key);

  // method to get the name by converting the first char to uppercase
  String getName(String name) {
    return name[0].toUpperCase() + name.substring(1);
  }

  // storing the moves
  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          colors[Provider.of<PokemonProvider>(context, listen: false).getType],
      appBar: AppBar(
        title: Text(
          getName('${pokemon.name}\'s moves'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SearchPage(SearchType.move),
              ),
            ),
          )
        ],
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: pokemon.moves.length,
        itemBuilder: (context, index) {
          return MoveTile(moveAndUrl: pokemon.moves[index], index: index);
        },
      ),
    );
  }
}
