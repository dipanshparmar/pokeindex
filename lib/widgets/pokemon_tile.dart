import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// providers
import '../providers/providers.dart';

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
        Provider.of<PokemonProvider>(context, listen: false)
            .getName(nameAndUrl['name']),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 15,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
