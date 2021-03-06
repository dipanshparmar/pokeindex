import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// providers
import '../providers/providers.dart';

// widgets
import '../widgets/widgets.dart';

// utils
import '../utils/utils.dart';

// pages
import '../pages/pages.dart';

class MoveTile extends StatefulWidget {
  const MoveTile({
    Key? key,
    required this.name,
    required this.url,
  }) : super(key: key);

  // holding the move name
  final String name;

  // holding the move url
  final String url;

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
      widget.url,
    );
  }

  // bool to store whether the tile is expanded or not
  bool _isExpanded = false; // initially to false

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        UtilityMethods.getName(
          widget.name,
        ),
        style: TextStyle(
          fontWeight: _isExpanded ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      onExpansionChanged: (value) {
        setState(() {
          // updating the expanded state
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
              // page that will be pushed
              Widget page = AllMovesPage(
                name: widget.name,
                moves: Provider.of<PokemonProvider>(context, listen: false)
                    .getPokemon
                    .moves,
              );

              // text to display
              String text = 'Something went wrong!';

              // if it is a socket exception
              if (snapshot.error.runtimeType == SocketException) {
                text = 'Either no internet connection or the server is down.';
              }

              // returning the error text
              return Column(
                children: [
                  ErrorText(text: text, page: page),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              );
            } else {
              // if no error then render the move description
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
