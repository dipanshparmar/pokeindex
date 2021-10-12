import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AbilityPage extends StatefulWidget {
  const AbilityPage(this.abilityData, {Key? key}) : super(key: key);

  // holding the ability data
  final Map abilityData;

  @override
  State<AbilityPage> createState() => _AbilityPageState();
}

class _AbilityPageState extends State<AbilityPage> {
  // method to get the name by converting the first char to uppercase
  String getName(String name) {
    return name[0].toUpperCase() + name.substring(1);
  }

  // this will hold the future that will load the ability description
  late final Future _future;

  // method to load the ability description
  Future<void> loadAbilityDescription() async {
    // making the get request
    final http.Response response = await http.get(
      Uri.parse(widget.abilityData['ability']['url']),
    );

    // decoding the response
    final decodedResponse = jsonDecode(response.body);

    // getting all the entries
    final List entries = decodedResponse['effect_entries'];

    // returning the entry with english language because the response order is different each time
    return entries.firstWhere(
      (element) => element['language']['name'] == 'en',
    )['effect'];
  }

  @override
  void initState() {
    super.initState();

    // assigning the future
    _future = loadAbilityDescription();
  }

  @override
  Widget build(BuildContext context) {
    loadAbilityDescription();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          getName(
            widget.abilityData['ability']['name'],
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
              return const Center(
                child: Text('err'), // TODO: UPDATE THIS
              );
            } else {
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
