import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  const ErrorText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Text(
          'Oops! Something went wrong. Try opening the page again or restarting the app and make sure that you have the internet access.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
