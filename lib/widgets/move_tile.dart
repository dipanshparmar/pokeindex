import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MoveTile extends StatefulWidget {
  const MoveTile({
    Key? key,
    required this.moveAndUrl,
    required this.index,
  }) : super(key: key);

  final Map moveAndUrl;
  final int index;

  @override
  State<MoveTile> createState() => _MoveTileState();
}

class _MoveTileState extends State<MoveTile> {
  // this will hold the future
  late Future _future;

  // method to get the info about a move
  Future<String> getMoveInfo() async {
    // making the get request
    final http.Response response = await http.get(
      Uri.parse(widget.moveAndUrl['move']['url']),
    );

    // decoding the response
    final decodedData = jsonDecode(response.body);

    // returning the move info
    return decodedData['effect_entries'][0]['effect'];
  }

  @override
  void initState() {
    super.initState();

    // assigning the future
    _future = getMoveInfo();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        widget.moveAndUrl['move']['name'],
      ),
      children: [
        FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            // if waiting
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
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
      childrenPadding: const EdgeInsets.all(20),
    );
  }
}
