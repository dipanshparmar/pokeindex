import 'dart:io';

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
              // page that will be pushed
              Widget page = EvolutionPage(widget._name);

              // text to display
              String text = 'Something went wrong!';

              // if it is a socket exception
              if (snapshot.error.runtimeType == SocketException) {
                text = 'Either no internet connection or the server is down.';
              }

              // returning the error text
              return ErrorText(text: text, page: page);
            } else {
              // getting the pokemon provider object
              final obj = Provider.of<PokemonProvider>(context, listen: false);

              // getting the initial pokemon name of the evolution
              final String initialPokemonNameOfEvolution =
                  obj.initialPokemonOfEvolution;

              // getting the list of list of maps that hold the data of the evolution
              final List<List<Map>> listOfListOfMap = obj.getPokemonsOfChain;

              // TODO: ADD FOR EMPTY LIST AS WELL

              // returning a column
              return ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  EvolutionTile(
                    name: initialPokemonNameOfEvolution,
                    subtitle: 'base',
                    number: 1,
                  ),
                  ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: listOfListOfMap.length,
                    itemBuilder: (context, indexOutside) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: listOfListOfMap[indexOutside].length,
                        itemBuilder: (context, indexInside) {
                          // getting current map data
                          final mapData =
                              listOfListOfMap[indexOutside][indexInside];

                          return Row(
                            children: [
                              SizedBox(
                                width: (20 * (indexInside + 1)).toDouble(),
                              ),
                              Expanded(
                                child: EvolutionTile(
                                  name: mapData['name'],
                                  subtitle:
                                      mapData['item'] ?? mapData['trigger'],
                                  number: indexInside + 2,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  )
                ],
              );
            }
          }
        },
      ),
    );
  }
}

class EvolutionTile extends StatelessWidget {
  const EvolutionTile({
    Key? key,
    required this.name,
    required this.subtitle,
    required this.number,
  }) : super(key: key);

  final String name;
  final int number;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PokemonPage(
            name,
            fromEvolution: true,
          ),
        ),
      ),
      title: Text(UtilityMethods.getName(name)),
      subtitle: Text(UtilityMethods.getName(subtitle)),
      trailing: Text(number.toString()),
    );
  }
}
