import 'package:flutter/material.dart';

// utils
import '../utils/utils.dart';

class DamageExpensionTile extends StatefulWidget {
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
  State<DamageExpensionTile> createState() => _DamageExpensionTileState();
}

class _DamageExpensionTileState extends State<DamageExpensionTile> {
  // bool to decide whether the tile is expanded or not
  bool _isExpanded = false; // initially false

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        widget.title,
        style: TextStyle(
          fontWeight: _isExpanded ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onExpansionChanged: (value) {
        setState(() {
          // updating the value and rebuilding the screen
          _isExpanded = value;
        });
      },

      // if there is some data about the damages against other types, then build that
      children: widget.types.isNotEmpty
          ? widget.types
              .map(
                (e) => ListTile(
                  title: Text(
                    UtilityMethods.getName(e['name']),
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  trailing: Text('x${widget.damage}'),
                ),
              )
              .toList()
          : [
              // otherwise just return none
              const ListTile(
                title: Text(
                  'None!',
                  style: TextStyle(fontSize: 14),
                ),
              )
            ],
      iconColor: Theme.of(context).primaryColor,
      textColor: Theme.of(context).primaryColor,
    );
  }
}
