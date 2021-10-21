import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

// providers
import '../providers/providers.dart';

class MoveTile extends StatefulWidget {
  const MoveTile({
    Key? key,
    required this.moveAndUrl,
  }) : super(key: key);

  final Map moveAndUrl;

  @override
  State<MoveTile> createState() => _MoveTileState();
}

class _MoveTileState extends State<MoveTile> {
  // this will hold the future
  late Future _future;

  @override
  void initState() {
    super.initState();

    // assigning the future
    _future = Provider.of<PokemonProvider>(context, listen: false).getMoveInfo(
      widget.moveAndUrl['move']['url'],
    );
  }

  // bool to store whether the tile is expanded or not
  bool _isExpanded = false; // initially to false

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        Provider.of<PokemonProvider>(context, listen: false).getName(
          widget.moveAndUrl['move']['name'],
        ),
        style: TextStyle(
          fontWeight: _isExpanded ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      onExpansionChanged: (value) {
        setState(() {
          _isExpanded = value;
        });
      },
      children: [
        FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            // if waiting
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LinearProgressIndicator(
                color: Theme.of(context).primaryColor,
                backgroundColor: const Color(0xFF9CABFF),
                minHeight: 3,
              );
            }

            // if loaded
            if (snapshot.hasError) {
              // if error
              return const Center(
                child: Text('err'), // TODO: UPDATE THIS
              );
            } else {
              // if no error
              return Text(snapshot.data as String);
            }
          },
        ),
      ],
      iconColor: Theme.of(context).primaryColor,
      textColor: Theme.of(context).primaryColor,
      childrenPadding: const EdgeInsets.only(right: 20, left: 20, bottom: 10),
    );
  }
}
