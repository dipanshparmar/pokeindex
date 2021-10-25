import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  const ErrorText({
    Key? key,
    required this.text,
    required this.page,
  }) : super(key: key);

  // error text
  final String text;

  // page to replace current page with on click of 'try again'
  final Widget page;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => page),
            ),
            child: Text(
              'Try again!',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
