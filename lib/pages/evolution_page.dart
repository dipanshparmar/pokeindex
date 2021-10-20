import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  // list of map to hold the evolution pokemon names and urls
  final List _pokemons = [];

  void fetchPokemonData(Map data) {
    // getting the name
    final String name = data['species']['name'];

    // appending the data
    _pokemons.add(name);

    // getting evolvesTo
    final List evolvesTo = data['evolves_to'];

    if (evolvesTo.isEmpty) {
      return;
    }

    fetchPokemonData(evolvesTo[0]);
  }

  // method to make the request
  Future<void> loadEvolutionData() async {
    // making the request to species data
    final http.Response speciesResponse = await http.get(
      Uri.parse('https://pokeapi.co/api/v2/pokemon-species/${widget._name}'),
    );

    // if response is not found then just return
    if (speciesResponse.body.toLowerCase() == 'not found') {
      return;
    }

    // decoding the response
    final data = jsonDecode(speciesResponse.body);

    // getting the evolution chain url
    final evolutionChainLink = data['evolution_chain']['url'];

    // making the request to the evolution chain
    final http.Response evolutionResponse = await http.get(
      Uri.parse(evolutionChainLink),
    );

    // decoding the body
    final chainData = jsonDecode(evolutionResponse.body);

    // getting the evolvesTo
    final evolvesTo = chainData['chain'];

    // fetching the pokemons
    fetchPokemonData(evolvesTo);
  }

  @override
  void initState() {
    super.initState();

    // assigning the future
    _future = loadEvolutionData();
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
                              _pokemons[index]!,
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
