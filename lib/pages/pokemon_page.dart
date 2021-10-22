import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// providers
import '../providers/providers.dart';

// utils
import '../utils/utils.dart';

// widgets
import '../widgets/widgets.dart';

// pages
import './pages.dart';

// models
import '../models/pokemon.dart';

class PokemonPage extends StatefulWidget {
  const PokemonPage(
    this._name, {
    Key? key,
    this.fromEvolution = false,
  }) : super(key: key);

  // getting the name of the pokemon
  final String _name;

  // to decide to show the evolution button or not
  // will be used when accessing this screen from the evolution page
  final bool fromEvolution;

  @override
  State<PokemonPage> createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  // this future will fetch the data of a pokemon
  late Future _fetchPokemonData;

  @override
  void initState() {
    super.initState();

    // assigning the future
    _fetchPokemonData = Provider.of<PokemonProvider>(context, listen: false)
        .fetchPokemonData(widget._name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          UtilityMethods.getName(widget._name),
        ),
      ),
      body: FutureBuilder(
        future: _fetchPokemonData,
        builder: (context, snapshot) {
          // if the data is currently loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          } else {
            // if the data has been loaded
            // if there is an error
            if (snapshot.hasError) {
              return const ErrorText();
            } else {
              // if there is data then render it by accessing from the provider
              return Consumer<PokemonProvider>(
                builder: (context, obj, child) {
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: colors[obj.getType],
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            physics: const BouncingScrollPhysics(),
                            children: [
                              Container(
                                height: 300,
                                padding: const EdgeInsets.all(20),
                                // if there is no image url then let the user know, otherwise build the image
                                child: obj.getPokemon.imageUrl != null
                                    ? FadeInImage.assetNetwork(
                                        placeholder:
                                            'assets/images/placeholder.png',
                                        image: obj.getPokemon.imageUrl!,
                                      )
                                    : const Center(
                                        child: Text('No image data!'),
                                      ),
                              ),
                              // building the stats that are attack, defense, etc.
                              _buildStats(obj.getPokemon),

                              // builing the different data e.g. types, weight, held items, etc.
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // building types
                                  const Heading('Type'),
                                  _buildTypes(obj.getPokemon.types),

                                  // building weight
                                  const Heading('Weight'),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0,
                                    ),
                                    child: CustomCard(
                                      '${obj.getPokemon.weight} Kg',
                                    ),
                                  ),

                                  // building abilites
                                  const Heading('Abilities'),
                                  _buildAbilities(obj.getPokemon.abilities),

                                  // if there are held items then print the heading
                                  if (obj.getPokemon.heldItems.isNotEmpty)
                                    const Heading('Held items'),
                                  // if there are held items then build them
                                  if (obj.getPokemon.heldItems.isNotEmpty)
                                    _buildHeldItems(obj),

                                  // if there are moves then build them
                                  if (obj.getPokemon.moves.isNotEmpty)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Heading('Moves'),
                                        // show the see all button only if the length of moves is greater than 10 (i.e. moves > 10)
                                        obj.getPokemon.moves.length > 10
                                            ? _buildSeeAllButton(obj.getPokemon)
                                            : const Text(''),
                                      ],
                                    ),
                                  // if there are moves then build them
                                  if (obj.getPokemon.moves.isNotEmpty)
                                    _buildMoves(obj.getPokemon.moves),

                                  // build some space from below
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        // building the about and the evolution button
                        _buildButtons(context),
                      ],
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }

  // method for stats build
  SingleChildScrollView _buildStats(Pokemon pokemon) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          const SizedBox(
            width: 20,
          ),
          StatsCard(
            icon: Icon(
              Icons.bolt,
              color: Colors.yellow.shade700,
            ),
            title: 'Attack',
            value: pokemon.attack,
          ),
          const SizedBox(
            width: 20,
          ),
          StatsCard(
            icon: const Icon(
              Icons.shield_outlined,
              color: Colors.green,
            ),
            title: 'Defense',
            value: pokemon.defense,
          ),
          const SizedBox(
            width: 20,
          ),
          StatsCard(
            icon: Icon(
              Icons.flash_on,
              color: Colors.yellow.shade700,
            ),
            title: 'Sp. attack',
            value: pokemon.specialAttack,
          ),
          const SizedBox(
            width: 20,
          ),
          StatsCard(
            icon: const Icon(
              Icons.shield_outlined,
              color: Colors.green,
            ),
            title: 'Sp. defense',
            value: pokemon.specialDefense,
          ),
          const SizedBox(
            width: 20,
          ),
          StatsCard(
            icon: const Icon(
              Icons.directions_run,
              color: Colors.indigo,
            ),
            title: 'Speed',
            value: pokemon.speed,
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  // method to build types
  Widget _buildTypes(List types) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 10),
        child: Row(
          children: types
              .map(
                (type) => GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TypePage(
                        name: type['type']['name'],
                        url: type['type']['url'],
                      ),
                    ),
                  ),
                  child: CustomCard(type['type']['name']),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  // method to build abilites
  Widget _buildAbilities(List abilities) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 10),
        child: Row(
          children: abilities
              .map(
                (ability) => GestureDetector(
                  onTap: () {
                    // pushing the ability page when there is a click on an ability
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AbilityPage(
                          name: ability['ability']['name'],
                          url: ability['ability']['url'],
                        ),
                      ),
                    );
                  },
                  child: CustomCard(ability['ability']['name']),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  // method to build held items
  Widget _buildHeldItems(PokemonProvider obj) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 10),
        child: Row(
          children: obj.getPokemon.heldItems
              .map(
                (e) => GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HeldItemPage(
                        e['item']['name'],
                        e['item']['url'],
                      ),
                    ),
                  ),
                  child: CustomCard(
                    UtilityMethods.getName(e['item']['name']),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  // method to build see all button
  GestureDetector _buildSeeAllButton(Pokemon pokemon) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AllMovesPage(
            name: pokemon.name,
            moves: pokemon.moves,
          ),
        ),
      ),
      child: Row(
        children: const [
          Text(
            'See all',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
    );
  }

  // method to build moves
  Widget _buildMoves(List moves) {
    // builing the moves
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 10),
        child: Row(
          // only showing 10 moves so that 'see more' button makes some sense
          children: moves
              .sublist(
                0,
                moves.length > 10 ? 10 : null,
              ) // if there are more than 10 moves then fetch first 10 moves only, otherwise fetch every move
              .map(
                (move) => GestureDetector(
                  onTap: () {
                    // pushing the move page when there is a click on the move
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovePage(
                          name: move['move']['name'],
                          url: move['move']['url'],
                        ),
                      ),
                    );
                  },
                  child: CustomCard(move['move']['name']),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  // method to build the buttons
  Padding _buildButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.black87,
                ),
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                ),
              ),
              onPressed: () {
                // pushing the about page with the name when there is a click on the about button
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AboutPage(widget._name),
                  ),
                );
              },
              child: const Text(
                'ABOUT',
                style: TextStyle(
                  letterSpacing: 1.3,
                  fontSize: 13,
                ),
              ),
            ),
          ),

          // if current screen was not pushed from the evolution page then add some spacing and the evolution button
          if (!widget.fromEvolution)
            const SizedBox(
              width: 20,
            ),
          if (!widget.fromEvolution)
            Expanded(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).primaryColor,
                  ),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                  ),
                ),
                onPressed: () {
                  // pushing the evolution page when there is a click on the evolution button
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EvolutionPage(widget._name),
                    ),
                  );
                },
                child: const Text(
                  'EVOLUTION',
                  style: TextStyle(
                    letterSpacing: 1.3,
                    fontSize: 13,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
