import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// providers
import '../providers/providers.dart';

// widgets
import '../widgets/widgets.dart';

// utils
import '../utils/utils.dart';

class SearchPage extends StatefulWidget {
  const SearchPage(this._searchType, {Key? key}) : super(key: key);

  // search type
  final SearchType _searchType;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // this will hold the value of the text field
  String searchQuery = '';

  // controller for the text field
  final _controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    // disposing the controller
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget._searchType == SearchType.pokemon
          ? Colors.white
          : colors[Provider.of<PokemonProvider>(context).getType],
      appBar: AppBar(
        title: TextField(
          textAlignVertical: TextAlignVertical.center,
          controller: _controller,
          autofocus: true,
          cursorColor: Colors.white70,
          decoration: InputDecoration(
            hintText: 'Search ...',
            hintStyle: const TextStyle(
              color: Colors.white70,
            ),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.cancel),
              color: Colors.white70,
              onPressed: () => setState(() {
                _controller.clear(); // clearing the value from the text field
                searchQuery = ''; // clearing the value of the search text
              }),
            ),
          ),
          style: const TextStyle(
            color: Colors.white,
          ),
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
        ),
      ),
      body: Consumer<PokemonProvider>(
        builder: (context, obj, child) {
          // if search query is not empty
          if (searchQuery.isNotEmpty) {
            // getting the search results according to the search type and the query
            final List results = obj.getSearchResults(
              searchType: widget._searchType,
              query: searchQuery,
            );

            // if there are results
            if (results.isNotEmpty) {
              return ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  // getting the current result
                  final result = results[index];

                  return widget._searchType == SearchType.pokemon
                      ? PokemonTile(
                          nameAndUrl: result,
                        )
                      : MoveTile(moveAndUrl: result);
                },
              );
            }

            // if there are no results
            return const Center(
              child: Text('No results!'),
            );
          }

          // if search query is empty
          return const Center(
            child: Text('Please type in something!'),
          );
        },
      ),
    );
  }
}
