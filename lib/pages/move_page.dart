import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// providers
import '../providers/providers.dart';

// widgets
import '../widgets/widgets.dart';

// utils
import '../utils/utils.dart';

class MovePage extends StatefulWidget {
  const MovePage({
    Key? key,
    required this.name,
    required this.url,
  }) : super(key: key);

  // storing the move name
  final String name;

  // storing the move url
  final String url;

  @override
  State<MovePage> createState() => _MovePageState();
}

class _MovePageState extends State<MovePage> {
  // this future will hold the future that will load the move description
  late Future _future;

  @override
  void initState() {
    super.initState();

    // assignign the future
    _future = Provider.of<PokemonProvider>(context, listen: false).loadMoveDesc(
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
            // if loaded
            // if error
            if (snapshot.hasError) {
              // page that will be pushed
              Widget page = MovePage(name: widget.name, url: widget.url);

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
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Text(snapshot.data as String),
              );
            }
          }
        },
      ),
    );
  }
}
