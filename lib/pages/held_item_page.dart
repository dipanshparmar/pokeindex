import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pokedex/widgets/widgets.dart';
import 'package:provider/provider.dart';

// providers
import '../providers/providers.dart';

// utils
import '../utils/utils.dart';

class HeldItemPage extends StatefulWidget {
  const HeldItemPage(this._name, this._url, {Key? key}) : super(key: key);

  // getting the name and the url of the held item
  final String _name;
  final String _url;

  @override
  State<HeldItemPage> createState() => _HeldItemPageState();
}

class _HeldItemPageState extends State<HeldItemPage> {
  // future to load the description of the held item
  late final Future _future;

  @override
  void initState() {
    super.initState();

    // assigning the future
    _future =
        Provider.of<PokemonProvider>(context, listen: false).loadHeldItemDesc(
      widget._url,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          UtilityMethods.getName(widget._name),
        ),
      ),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          // if loading then return a circular bar
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          } else {
            // if completed
            // if error
            if (snapshot.hasError) {
              // page that will be pushed
              Widget page = HeldItemPage(widget._name, widget._url);

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
