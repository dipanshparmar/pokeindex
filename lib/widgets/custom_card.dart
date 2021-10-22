import 'package:flutter/material.dart';

// utils
import '../utils/utils.dart';

class CustomCard extends StatelessWidget {
  const CustomCard(this.text, {Key? key}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white60,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(right: 10),
      child: Text(
        UtilityMethods.getName(text),
      ),
    );
  }
}
