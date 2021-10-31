import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// providers
import '../providers/pokemon_provider.dart';

// widgets
import '../widgets/widgets.dart';

// utils
import '../utils/utils.dart';

class AbilityPage extends StatefulWidget {
  const AbilityPage({
    Key? key,
    required this.name,
    required this.url,
  }) : super(key: key);

  // holding the ability name
  final String name;

  // holding the ability url
  final String url;

  @override
  State<AbilityPage> createState() => _AbilityPageState();
}

class _AbilityPageState extends State<AbilityPage> {
  // this will hold the future that will load the ability description
  late final Future _future;

  @override
  void initState() {
    super.initState();

    // assigning the future
    _future = Provider.of<PokemonProvider>(context, listen: false)
        .loadAbilityDescription(
      widget.url,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          UtilityMethods.getName(
            widget.name,
          ),
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
            // if error
            if (snapshot.hasError) {
              print(snapshot.error);
              // page that will be pushed
              Widget page = AbilityPage(
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
              // if data
              // if no description found then let the user know
              if ((snapshot.data as String).toLowerCase() ==
                  'no description found!') {
                return Center(
                  child: Text(snapshot.data as String),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(snapshot.data as String),
              );
            }
          }
        },
      ),
    );
  }
}
