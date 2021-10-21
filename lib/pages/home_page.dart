import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// providers
import '../providers/providers.dart';

// pages
import './pages.dart';

// widgets
import '../widgets/widgets.dart';

// utils
import '../utils/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future _loadPokemonsInfo;

  @override
  void initState() {
    super.initState();

    // assigning the future
    _loadPokemonsInfo =
        Provider.of<PokemonProvider>(context, listen: false).fetchPokemons();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<PokemonProvider>(context, listen: false).fetchPokemons();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokedex'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SearchPage(SearchType.pokemon),
              ),
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: _loadPokemonsInfo,
        builder: (context, snapshot) {
          // if the data is loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          } else {
            // if the data is loaded
            // if an error is encountered
            if (snapshot.hasError) {
              return const ErrorText();
            } else {
              // if everything was succesful
              return Consumer<PokemonProvider>(
                builder: (context, obj, child) {
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: obj.getNamesAndUrls.length,
                    itemBuilder: (context, index) {
                      // current name and url
                      final nameAndUrl = obj.getNamesAndUrls[index];

                      return PokemonTile(nameAndUrl: nameAndUrl, index: index);
                    },
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
