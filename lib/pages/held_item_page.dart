import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// providers
import '../providers/providers.dart';

class HeldItemPage extends StatefulWidget {
  const HeldItemPage(this._name, this._url, {Key? key}) : super(key: key);

  // getting the name and the url
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
        title: Text(widget._name),
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
            // if completed
            // if error
            if (snapshot.hasError) {
              return const Text('err'); // TODO: UPDATE THIS
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
