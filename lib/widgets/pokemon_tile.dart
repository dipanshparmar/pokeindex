import 'package:flutter/material.dart';

// pages
import '../pages/pages.dart';

class PokemonTile extends StatelessWidget {
  const PokemonTile({
    Key? key,
    required this.nameAndUrl,
    this.index,
  }) : super(key: key);

  final Map nameAndUrl;

  // index
  final int? index;

  // method to get the name by converting the first char to uppercase
  String getName(String name) {
    return name[0].toUpperCase() + name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PokemonPage(
            nameAndUrl['name'],
          ),
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
        getName(nameAndUrl['name']),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 15,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
