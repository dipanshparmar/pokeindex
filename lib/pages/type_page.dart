import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// providers
import '../providers/providers.dart';

// widgets
import '../widgets/widgets.dart';

// utils
import '../utils/utils.dart';

class TypePage extends StatefulWidget {
  const TypePage({
    Key? key,
    required this.name,
    required this.url,
  }) : super(key: key);

  // holding the type name
  final String name;

  // holding the type url
  final String url;

  @override
  State<TypePage> createState() => _TypePageState();
}

class _TypePageState extends State<TypePage> {
  // this will hold the future that will load the description of the type
  late Future _future;

  @override
  void initState() {
    super.initState();

    // assigning the future
    _future =
        Provider.of<PokemonProvider>(context, listen: false).getTypeDamageInfo(
      widget.url,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          UtilityMethods.getName(widget.name),
        ),
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
            // if loading is complete
            // if error
            if (snapshot.hasError) {
              // page that will be pushed
              Widget page = TypePage(
                name: widget.name,
                url: widget.url,
              );

              // text to display
              String text = 'Something went wrong!';

              // if it is a socket exception
              if (snapshot.error.runtimeType == SocketException) {
                text = 'Either no internet connection or the server is down.';
              }

              // returning the error text
              return ErrorText(text: text, page: page);
            } else {
              // if no error
              // get the data
              final Map data = snapshot.data as Map;

              // getting the double damage from data
              final List doubleDamageFrom =
                  data['damage_relations']['double_damage_from'];

              // getting the double damage to
              final List doubleDamageTo =
                  data['damage_relations']['double_damage_to'];

              // getting the half damage from
              final List halfDamageFrom =
                  data['damage_relations']['half_damage_from'];

              // getting the half damage to
              final List halfDamageTo =
                  data['damage_relations']['half_damage_to'];

              // getting no damage from
              final List noDamageFrom =
                  data['damage_relations']['no_damage_from'];

              // getting no damage from
              final List noDamageTo = data['damage_relations']['no_damage_to'];

              // rendering the data in tiles
              return ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  DamageExpensionTile(
                    damage: 2,
                    title: 'Double damage from',
                    types: doubleDamageFrom,
                  ),
                  DamageExpensionTile(
                    title: 'Double damage to',
                    types: doubleDamageTo,
                    damage: 2,
                  ),
                  DamageExpensionTile(
                    title: 'Half damage from',
                    types: halfDamageFrom,
                    damage: .5,
                  ),
                  DamageExpensionTile(
                    title: 'Half damage to',
                    types: halfDamageTo,
                    damage: .5,
                  ),
                  DamageExpensionTile(
                    title: 'No damage from',
                    types: noDamageFrom,
                    damage: 0,
                  ),
                  DamageExpensionTile(
                    title: 'No damage to',
                    types: noDamageTo,
                    damage: 0,
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
