import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// models
import '../models/models.dart';

// utils
import '../utils/utils.dart';

class PokemonProvider with ChangeNotifier {
  // this list will hold the map of the name and the url
  List<dynamic> _pokemonNameAndUrl = [];

  // this will store the selected pokemon data
  late Pokemon _pokemon;

  // method to fetch pokemon names and URLs
  Future<void> fetchPokemons() async {
    // making the get request
    final http.Response response = await http.get(
      Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=-1'),
    );

    // decoding the response
    final decodedResponse = jsonDecode(response.body);

    // getting the results
    final results = decodedResponse['results'];

    // assigning the results to the pokemonNameAndUrl
    _pokemonNameAndUrl = results;
  }

  // method to get names and urls
  get getNamesAndUrls {
    return [..._pokemonNameAndUrl];
  }

  // method to fetch the data for a specific pokemon
  Future<void> fetchPokemonData(String name) async {
    // making the get request
    final http.Response response = await http.get(
      Uri.parse('https://pokeapi.co/api/v2/pokemon/$name'),
    );

    // decoding the data
    final decodedData = jsonDecode(response.body);

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
  }

  Future<String> getDescription(String url) async {
    // making the request
    final http.Response response = await http.get(Uri.parse(url));

    // decoding the response
    final decodedResponse = jsonDecode(response.body);

    // returning the first description
    return (decodedResponse['flavor_text_entries'][0]['flavor_text'] as String)
        .replaceAll('\n', ' ');
  }

  int getWeightInKg(int weight) {
    return weight ~/ 10;
  }

  // getter to get the type
  get getType {
    return _pokemon.types[0]['type']['name'];
  }

  // getter to get the pokemon
  Pokemon get getPokemon {
    return _pokemon;
  }

  // method to get results according to the search query
  List<dynamic> getSearchResults(
      {required SearchType searchType, required String query}) {
    // if search type is pokemon
    if (searchType == SearchType.pokemon) {
      return _pokemonNameAndUrl
          .where((element) => element['name'].contains(query))
          .toList();
    } else {
      // if search type is move
      return _pokemon.moves
          .where((element) => element['move']['name'].contains(query))
          .toList();
    }
  }

  // method to load the ability description
  Future<String> loadAbilityDescription(String url) async {
    // making the get request
    final http.Response response = await http.get(
      Uri.parse(url),
    );

    // decoding the response
    final decodedResponse = jsonDecode(response.body);

    // getting all the entries
    final List entries = decodedResponse['effect_entries'];

    // returning the entry with english language because the response order is different each time
    return entries.firstWhere(
      (element) => element['language']['name'] == 'en',
    )['effect'];
  }

  // method to load about
  Future<String> loadAbout(String pokemonName) async {
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
  }

  // method to load held item description
  Future<String> loadHeldItemDesc(String url) async {
    // making the get request
    final http.Response response = await http.get(
      Uri.parse(url),
    );

    // decoding the response
    final decodedResponse = jsonDecode(response.body);

    // returning the effect entry
    return decodedResponse['effect_entries'][0]['effect'];
  }
}
