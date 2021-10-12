import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  const StatsCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
  }) : super(key: key);

  // title
  final String title;

  // value
  final int value;

  // icon
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            color: Colors.black12.withOpacity(.02),
            spreadRadius: 2,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          icon,
          const SizedBox(
            height: 15,
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.black54,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            value.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          )
        ],
      ),
    );
  }
}
