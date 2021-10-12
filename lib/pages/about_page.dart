import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AboutPage extends StatefulWidget {
  const AboutPage(this._name, {Key? key}) : super(key: key);

  // getting the name and the url
  final String _name;

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  // this future will load the pokemon info
  late Future _future;

  // method to load about
  Future<String> loadAbout() async {
    // making the get request
    final http.Response response = await http.get(
      Uri.parse('https://pokeapi.co/api/v2/pokemon-species/${widget._name}'),
    );

    // decoding the repsonse
    final decodedResponse = jsonDecode(response.body);

    return (decodedResponse['flavor_text_entries'][0]['flavor_text'] as String)
        .replaceAll('\n', ' ');
  }

  @override
  void initState() {
    super.initState();

    // assigning the future
    _future = loadAbout();
  }

  @override
  Widget build(BuildContext context) {
    loadAbout();
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget._name}\'s about'),
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
              return const Center(
                child: Text('err'), // TODO: UPDATE THIS
              );
            } else {
              // if loaded
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
