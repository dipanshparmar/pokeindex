import 'package:flutter/material.dart';

class DamageExpensionTile extends StatelessWidget {
  const DamageExpensionTile({
    Key? key,
    required this.title,
    required this.types,
    required this.damage,
  }) : super(key: key);

  // hold the title
  final String title;

  // hold the types
  final List types;

  // hold the damage amount
  final double damage;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      children: types.isNotEmpty
          ? types
              .map(
                (e) => ListTile(
                  title: Text(e['name']),
                  trailing: Text('x$damage'),
                ),
              )
              .toList()
          : [
              const ListTile(
                title: Text('None!'),
              )
            ],
      iconColor: Theme.of(context).primaryColor,
      textColor: Theme.of(context).primaryColor,
    );
  }
}
