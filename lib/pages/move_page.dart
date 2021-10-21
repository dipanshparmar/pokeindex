import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// providers
import '../providers/providers.dart';

class MovePage extends StatefulWidget {
  const MovePage(this.moveData, {Key? key}) : super(key: key);

  // storing the move map with name and url
  final Map moveData;

  @override
  State<MovePage> createState() => _MovePageState();
}

class _MovePageState extends State<MovePage> {
  // method to get the name by converting the first char to uppercase
  String getName(String name) {
    return name[0].toUpperCase() + name.substring(1);
  }

  // this future will hold the future that will load the move description
  late Future _future;

  @override
  void initState() {
    super.initState();

    // assignign the future
    _future = Provider.of<PokemonProvider>(context, listen: false).loadMoveDesc(
      widget.moveData['move']['url'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          getName(widget.moveData['move']['name']),
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
                child: Text('err'), // TODO: UDPATE THIS
              );
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
