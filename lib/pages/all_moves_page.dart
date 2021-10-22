import 'package:flutter/material.dart';

// utils
import '../utils/utils.dart';

// pages
import './pages.dart';

// widgets
import '../widgets/widgets.dart';

class AllMovesPage extends StatelessWidget {
  const AllMovesPage({
    Key? key,
    required this.name,
    required this.moves,
  }) : super(key: key);

  // storing the pokemon name
  final String name;

  // storing the moves
  final List moves;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          UtilityMethods.getName('$name\'s moves'),
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
        itemCount: moves.length,
        itemBuilder: (context, index) {
          return MoveTile(
            name: moves[index]['move']['name'],
            url: moves[index]['move']['url'],
          );
        },
      ),
    );
  }
}
