import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// providers
import '../providers/providers.dart';

// widggets
import '../widgets/widgets.dart';

// utils
import '../utils/utils.dart';

class AboutPage extends StatefulWidget {
  const AboutPage(this._name, {Key? key}) : super(key: key);

  // getting the name of the pokemon
  final String _name;

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  // this future will load the pokemon info
  late Future _future;

  @override
  void initState() {
    super.initState();

    // assigning the future
    _future = Provider.of<PokemonProvider>(context, listen: false).loadAbout(
      widget._name,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          UtilityMethods.getName('${widget._name}\'s about'),
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
            // if loading finished
            // if error
            if (snapshot.hasError) {
              // page that will be pushed
              Widget page = AboutPage(widget._name);

              // text to display
              String text = 'Something went wrong!';

              // if it is a socket exception
              if (snapshot.error.runtimeType == SocketException) {
                text = 'Either no internet connection or the server is down.';
              }

              // returning the error text
              return ErrorText(text: text, page: page);
            } else {
              // if loaded
              // if data not found then let the user know
              if ((snapshot.data as String).toLowerCase() ==
                  'no about data found!') {
                return Center(
                  child: Text(snapshot.data as String),
                );
              }

              // else show the data
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
