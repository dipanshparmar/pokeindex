import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// providers
import '../providers/providers.dart';

// widgets
import '../widgets/widgets.dart';

// utils
import '../utils/utils.dart';

class TypePage extends StatefulWidget {
  const TypePage(this._type, {Key? key}) : super(key: key);

  // holding the type name and the url
  final Map _type;

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
      widget._type['type']['url'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          UtilityMethods.getName(widget._type['type']['name']),
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
              return const ErrorText();
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
