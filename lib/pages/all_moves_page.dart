import 'package:flutter/material.dart';

// models
import '../models/models.dart';

// utils
import '../utils/utils.dart';

// pages
import './pages.dart';

// widgets
import '../widgets/widgets.dart';

class AllMovesPage extends StatelessWidget {
  const AllMovesPage(this._pokemon, {Key? key}) : super(key: key);

  // storing the moves
  final Pokemon _pokemon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          UtilityMethods.getName('${_pokemon.name}\'s moves'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // pushing the search page when there is a click on the search icon in the all moves page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchPage(SearchType.move),
                ),
              );
            },
          )
        ],
      ),
      // rendering the moves
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: _pokemon.moves.length,
        itemBuilder: (context, index) {
          return MoveTile(moveAndUrl: _pokemon.moves[index]);
        },
      ),
    );
  }
}
