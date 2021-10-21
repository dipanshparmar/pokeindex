import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// providers
import '../providers/providers.dart';

// pages
import './pages.dart';

class EvolutionPage extends StatefulWidget {
  const EvolutionPage(this._name, {Key? key}) : super(key: key);

  // name
  final String _name;

  @override
  _EvolutionPageState createState() => _EvolutionPageState();
}

class _EvolutionPageState extends State<EvolutionPage> {
  // to store the future
  late Future _future;

  @override
  void initState() {
    super.initState();

    // assigning the future
    _future = Provider.of<PokemonProvider>(context, listen: false)
        .loadEvolutionData(widget._name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget._name}\'s evolution'),
      ),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          // if loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          } else {
            // if error
            if (snapshot.hasError) {
              return const Text('err'); // TODO: update this
            } else {
              // if data
              // getting the pokemons from the chain once the fetching is complete
              final List<String> _pokemons =
                  Provider.of<PokemonProvider>(context, listen: false)
                      .getPokemonsOfChain;

              if (_pokemons.isNotEmpty) {
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _pokemons.length,
                  itemBuilder: (context, index) {
                    // current pokemon
                    final pokemon = _pokemons[index];

                    return ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PokemonPage(
                              _pokemons[index],
                              fromEvolution: true,
                            ),
                          ),
                        );
                      },
                      title: Text(
                        pokemon,
                        style: TextStyle(
                          color: widget._name == pokemon
                              ? Theme.of(context).primaryColor
                              : null,
                        ),
                      ),
                      trailing: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: widget._name == pokemon
                              ? Theme.of(context).primaryColor
                              : null,
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text('No evolution data found!'),
                );
              }
            }
          }
        },
      ),
    );
  }
}
