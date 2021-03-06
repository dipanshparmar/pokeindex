import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// models
import '../models/models.dart';

// utils
import '../utils/utils.dart';

class PokemonProvider with ChangeNotifier {
  // this list will hold the names of the pokemons
  final List<dynamic> _pokemonsNames = [];

  // this will store the selected pokemon data
  late Pokemon _pokemon;

  // this will hold the initial pokemon name of the evolution
  String? _initialPokemonOfEvolution;

  // list of map to hold the evolution pokemon names
  final List<List<Map>> _pokemonsFromChain = [];

  // temporary list to hold the data of nest evolution chains, will work parallaly with the _pokemonsFromChain list
  List<Map> _tmpEvolutionChainPokemons = [];

  // method to fetch pokemon names and URLs
  Future<void> fetchPokemons() async {
    try {
      // making the get request
      final http.Response response = await http.get(
        Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=-1'),
      );

      // decoding the response
      final Map decodedResponse = jsonDecode(response.body);

      // getting the results
      final List results = decodedResponse['results'];

      // emptying the names
      _pokemonsNames.clear();

      // assigning the names to the _pokemonsName
      for (int i = 0; i < results.length; i++) {
        _pokemonsNames.add(results[i]['name']);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  // method to fetch the data for a specific pokemon
  Future<void> fetchPokemonData(String name) async {
    try {
      // making the get request
      final http.Response response = await http.get(
        Uri.parse('https://pokeapi.co/api/v2/pokemon/$name'),
      );

      // decoding the data
      final Map decodedData = jsonDecode(response.body);

      // getting the id
      final int id = decodedData['id'];

      // getting the image url
      final String? imageUrl =
          decodedData['sprites']['other']['official-artwork']['front_default'];

      // getting the hp
      final int hp = decodedData['stats'][0]['base_stat'];

      // getting the attack
      final int attack = decodedData['stats'][1]['base_stat'];

      // getting the defense
      final int defense = decodedData['stats'][2]['base_stat'];

      // getting the special attack
      final int specialAttack = decodedData['stats'][3]['base_stat'];

      // getting the special defense
      final int specialDefense = decodedData['stats'][4]['base_stat'];

      // getting the speed
      final int speed = decodedData['stats'][5]['base_stat'];

      // getting the weight
      final int weight = getWeightInKg(
        decodedData['weight'],
      ); // default to hectogram

      // getting the abilites
      final List abilities = decodedData['abilities'];

      // getting the moves
      final List moves = decodedData['moves'];

      // getting the types
      final List types = decodedData['types'];

      // getting the held items
      final List heldItems = decodedData['held_items'];

      // updating the pokemon object
      _pokemon = Pokemon(
        id: id,
        abilities: abilities,
        attack: attack,
        defense: defense,
        hp: hp,
        imageUrl: imageUrl,
        moves: moves,
        name: name,
        specialAttack: specialAttack,
        specialDefense: specialDefense,
        speed: speed,
        types: types,
        weight: weight,
        heldItems: heldItems,
      );
    } catch (e) {
      return Future.error(e);
    }
  }

  // method to get results according to the search query
  List<dynamic> getSearchResults({
    required SearchType searchType,
    required String query,
  }) {
    // if search type is pokemon
    if (searchType == SearchType.pokemon) {
      return _pokemonsNames
          .where((name) => name.contains(query.trim()))
          .toList();
    } else {
      // if search type is move
      return _pokemon.moves
          .where((move) => move['move']['name'].contains(query))
          .toList();
    }
  }

  // method to load the ability description
  Future<String> loadAbilityDescription(String url) async {
    try {
      // making the get request
      final http.Response response = await http.get(
        Uri.parse(url),
      );

      // decoding the response
      final Map decodedResponse = jsonDecode(response.body);

      // getting all the entries
      final List entries = decodedResponse['effect_entries'];

      // if there are entries
      if (entries.isNotEmpty) {
        // returning the entry with english language because the response order is different each time
        return entries.firstWhere(
          (element) => element['language']['name'] == 'en',
        )['effect'];
      } else {
        // if there are no effect entries then return the flavor_text_entry that is in english
        // getting the flavor_text_entries
        final List flavorTextEntries = decodedResponse['flavor_text_entries'];

        // try to return the english text
        try {
          return flavorTextEntries.firstWhere(
              (element) => element['language']['name'] == 'en')['flavor_text'];
        } catch (e) {
          // if no english text is found or the list is empty then just return that no description found
          return 'No description found!';
        }
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  // method to load about
  Future<String> loadAbout(String pokemonName) async {
    try {
      // making the get request
      final http.Response response = await http.get(
        Uri.parse('https://pokeapi.co/api/v2/pokemon-species/$pokemonName'),
      );

      // getting the body
      final body = response.body;

      // if response not found then let the user know
      if (body.toLowerCase() == 'not found') {
        return 'No about data found!';
      }

      // if there is response then work with it

      // decoding the repsonse
      final decodedResponse = jsonDecode(response.body);

      // getting all the entries
      final List entries = decodedResponse['flavor_text_entries'];

      // returning the flavor text that is in english
      for (int i = 0; i < entries.length; i++) {
        if (entries[i]['language']['name'] == 'en') {
          return entries[i]['flavor_text'].replaceAll('\n', ' ');
        }
      }

      // if no en entry found then return the first one
      return entries[0]['flavor_text'].replaceAll('\n', ' ');
    } catch (e) {
      return Future.error(e);
    }
  }

  // method to load held item description
  Future<String> loadHeldItemDesc(String url) async {
    try {
      // making the get request
      final http.Response response = await http.get(
        Uri.parse(url),
      );

      // decoding the response
      final Map decodedResponse = jsonDecode(response.body);

      // returning the effect entry
      return decodedResponse['effect_entries'][0]['effect'];
    } catch (e) {
      return Future.error(e);
    }
  }

  // this method will load the move description
  Future<void> loadMoveDesc(String url) async {
    try {
      // making the get request
      final http.Response response = await http.get(
        Uri.parse(url),
      );

      // decoding the response
      final Map decodedResponse = jsonDecode(response.body);

      // try to return the move info
      return decodedResponse['effect_entries'].firstWhere(
          (element) => element['language']['name'] == 'en')['effect'];
    } catch (e) {
      return Future.error(e);
    }
  }

  // method to get the damage info of the type
  Future<Map> getTypeDamageInfo(String url) async {
    try {
      // making the get request
      final http.Response response = await http.get(
        Uri.parse(url),
      );

      // decoding response
      final Map decodedData = jsonDecode(response.body);

      return decodedData;
    } catch (e) {
      return Future.error(e);
    }
  }

  // method to find each pokemon's name and url from the chain
  // works together with loadEvolutionData method
  void fetchPokemonDataFromEvolutionChain(List data) {
    // getting the list size
    final int size = data.length;

    // for each map in the passed list data
    for (int i = 0; i < size; i++) {
      // getting current map data
      final Map mapData = data[i];

      // getting the evolution details
      final Map evolutionDetails = mapData['evolution_details'][0];

      // getting the trigger
      final String trigger = evolutionDetails['trigger']['name'];

      // getting the item map with the name and the url. can be null if the evolution is by levelling up
      final Map? itemMap = evolutionDetails['item'];

      // getting the pokemon name
      final String name = mapData['species']['name'];

      // pushing the map of the data to the _tmpEvolutionChainPokemons
      _tmpEvolutionChainPokemons.add({
        'name': name,
        'trigger': trigger,
        'item': itemMap != null ? itemMap['name'] : null,
      });

      // getting evolves to
      final List evolvesTo = mapData['evolves_to'];

      // if evolves to is not empty then pass this new data to the recursive call
      if (evolvesTo.isNotEmpty) {
        fetchPokemonDataFromEvolutionChain(evolvesTo);
      }

      // pushing the data from the tmp list to the main list
      _pokemonsFromChain.add(_tmpEvolutionChainPokemons);

      // clearing the temporary list for the next usage
      _tmpEvolutionChainPokemons = [];
    }
  }

  // method to load the chain
  Future<void> loadEvolutionData(String pokemonName) async {
    try {
      // making the request to species data
      final http.Response speciesResponse = await http.get(
        Uri.parse('https://pokeapi.co/api/v2/pokemon-species/$pokemonName'),
      );

      // clearing the previous data from the list
      _pokemonsFromChain.clear();

      // if response is not found then just return
      if (speciesResponse.body.toLowerCase() == 'not found') {
        // clearing the name if there is any
        _initialPokemonOfEvolution = null;
        return;
      }

      // decoding the response
      final Map data = jsonDecode(speciesResponse.body);

      // getting the evolution chain url
      final String evolutionChainLink = data['evolution_chain']['url'];

      // making the request to the evolution chain
      final http.Response evolutionResponse = await http.get(
        Uri.parse(evolutionChainLink),
      );

      // decoding the body
      final Map chainData = jsonDecode(evolutionResponse.body);

      // getting the initial pokemon name
      final String name = chainData['chain']['species']['name'];

      // setting the initial pokemon name from evolution
      _initialPokemonOfEvolution = name;

      // getting the evolvesTo
      final List evolvesTo = chainData['chain']['evolves_to'];

      // fetching the pokemons
      fetchPokemonDataFromEvolutionChain(evolvesTo);
    } catch (e) {
      return Future.error(e);
    }
  }

  // method to get the info about a move
  Future<String> getMoveInfo(String url) async {
    try {
      // making the get request
      final http.Response response = await http.get(
        Uri.parse(url),
      );

      // decoding the response
      final Map decodedData = jsonDecode(response.body);

      // returning the move info
      return decodedData['effect_entries'][0]['effect'];
    } catch (e) {
      return Future.error(e);
    }
  }

  // method to get names of the pokemons that are initially fetched
  List<String> get getNames {
    return [..._pokemonsNames];
  }

  // getter to get the pokemons of the chain
  List<List<Map>> get getPokemonsOfChain {
    return _pokemonsFromChain;
  }

  int getWeightInKg(int weight) {
    return weight ~/ 10;
  }

  // getter to get the type
  String get getType {
    return _pokemon.types[0]['type']['name'];
  }

  // getter to get the pokemon
  Pokemon get getPokemon {
    return _pokemon;
  }

  // getter to get the initial pokemon name of the evolution
  String? get initialPokemonOfEvolution {
    return _initialPokemonOfEvolution;
  }
}
