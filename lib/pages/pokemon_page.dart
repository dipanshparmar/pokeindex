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
  const PokemonPage(this._name, {Key? key}) : super(key: key);

  // getting the name and url of the pokemon
  final String _name;

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

  // method to get the name by converting the first char to uppercase
  String getName(String name) {
    return name[0].toUpperCase() + name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._name),
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
              return const Text('err'); // TODO: UPDATE THIS
            } else {
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
                              _buildStats(obj),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Heading('Type'),
                                  _buildTypes(obj),
                                  const Heading('Weight'),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0,
                                    ),
                                    child: CustomCard(
                                      '${obj.getPokemon.weight} Kg',
                                    ),
                                  ),
                                  const Heading('Abilities'),
                                  _buildAbilities(obj),
                                  if (obj.getPokemon.heldItems.isNotEmpty)
                                    const Heading('Held items'),
                                  if (obj.getPokemon.heldItems.isNotEmpty)
                                    _buildHeldItems(obj),
                                  if (obj.getPokemon.moves.isNotEmpty)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Heading('Moves'),
                                        // show the see all button only if there are moves > 10
                                        obj.getPokemon.moves.length > 10
                                            ? _buildSeeAllButton(obj.getPokemon)
                                            : const Text(''),
                                      ],
                                    ),
                                  if (obj.getPokemon.moves.isNotEmpty)
                                    _buildMoves(obj),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
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
                  child: CustomCard(e['item']['name']),
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
          builder: (context) => AllMovesPage(pokemon),
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
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutPage(widget._name),
                ),
              ),
              child: const Text(
                'ABOUT',
                style: TextStyle(
                  letterSpacing: 1.3,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
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
              onPressed: () {},
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

  // method to build moves
  Widget _buildMoves(PokemonProvider obj) {
    // getting the moves
    final moves = obj.getPokemon.moves;

    // builing the moves
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 10),
        child: Row(
          // only showing 10 moves
          children: moves
              .sublist(
                0,
                moves.length > 10 ? 10 : null,
              ) // if there are more than 10 moves then fetch first 10 moves only, otherwise fetch every move
              .map(
                (e) => GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovePage(e),
                    ),
                  ),
                  child: CustomCard(
                    getName(e['move']['name']),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  // method to build abilites
  Widget _buildAbilities(PokemonProvider obj) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 10),
        child: Row(
          children: obj.getPokemon.abilities
              .map(
                (e) => GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AbilityPage(e),
                    ),
                  ),
                  child: CustomCard(
                    getName(e['ability']['name']),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  // method to build types
  Widget _buildTypes(PokemonProvider obj) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 10),
        child: Row(
          children: obj.getPokemon.types
              .map(
                (e) => GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TypePage(e),
                    ),
                  ),
                  child: CustomCard(
                    getName(e['type']['name']),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  // method for stats build
  SingleChildScrollView _buildStats(PokemonProvider obj) {
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
            value: obj.getPokemon.attack,
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
            value: obj.getPokemon.defense,
          ),
          const SizedBox(
            width: 20,
          ),
          StatsCard(
            icon: Icon(
              Icons.flash_on,
              color: Colors.yellow.shade700,
            ),
            title: 'S. attack',
            value: obj.getPokemon.specialAttack,
          ),
          const SizedBox(
            width: 20,
          ),
          StatsCard(
            icon: const Icon(
              Icons.shield_outlined,
              color: Colors.green,
            ),
            title: 'S. defense',
            value: obj.getPokemon.specialDefense,
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
            value: obj.getPokemon.speed,
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }
}
