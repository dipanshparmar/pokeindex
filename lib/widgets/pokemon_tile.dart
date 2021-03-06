import 'package:flutter/material.dart';

// pages
import '../pages/pages.dart';

// utils
import '../utils/utils.dart';

class PokemonTile extends StatelessWidget {
  const PokemonTile(
    this._name, {
    Key? key,
    this.index,
  }) : super(key: key);

  //
  final String _name;

  // index
  final int? index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PokemonPage(_name),
        ),
      ),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          index != null
              ? Text('${index! + 1}')
              : Icon(
                  Icons.circle,
                  color: Theme.of(context).primaryColor,
                  size: 5,
                ),
        ],
      ),
      title: Text(
        UtilityMethods.getName(_name),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 15,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
