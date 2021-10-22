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

class EvolutionPage extends StatefulWidget {
  const EvolutionPage(this._name, {Key? key}) : super(key: key);

  // name of the pokemon
  final String _name;

  @override
  _EvolutionPageState createState() => _EvolutionPageState();
}

class _EvolutionPageState extends State<EvolutionPage> {
  // to store the future that will load the evolution data
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
        title: Text(
          UtilityMethods.getName('${widget._name}\'s evolution'),
        ),
      ),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          // if loading then return a loading bar
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          } else {
            // if error
            if (snapshot.hasError) {
              return const ErrorText();
            } else {
              // if data
              // getting the pokemons from the chain once the fetching is complete
              final List<String> _pokemons =
                  Provider.of<PokemonProvider>(context, listen: false)
                      .getPokemonsOfChain;

              // if there is pokemon's data then render that
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
                        UtilityMethods.getName(pokemon),
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
              } else { // if no data then let the user know
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
