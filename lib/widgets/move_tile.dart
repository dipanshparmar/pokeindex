import 'package:flutter/material.dart';

class MoveTile extends StatelessWidget {
  const MoveTile({
    Key? key,
    required this.moveAndUrl,
    required this.index,
  }) : super(key: key);

  final Map moveAndUrl;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            moveAndUrl['move']['name'],
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Theme.of(context).primaryColor,
            size: 15,
          ),
        ),
      ],
    );
  }
}
