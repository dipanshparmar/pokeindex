import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// providers
import '../providers/providers.dart';

// widgets
import '../widgets/widgets.dart';

class TypePage extends StatefulWidget {
  const TypePage(this.type, {Key? key}) : super(key: key);

  // type
  final Map type;

  @override
  State<TypePage> createState() => _TypePageState();
}

class _TypePageState extends State<TypePage> {
  // this will hold the future that will load the description of the type
  late Future _future;

  // method to get the name by converting the first char to uppercase
  String getName(String name) {
    return name[0].toUpperCase() + name.substring(1);
  }

  @override
  void initState() {
    super.initState();

    // assigning the future
    _future =
        Provider.of<PokemonProvider>(context, listen: false).getTypeDamageInfo(
      widget.type['type']['url'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getName(widget.type['type']['name'])),
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
              return const Center(
                child: Text('err'), // TODO: UPDATE THIS
              );
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
