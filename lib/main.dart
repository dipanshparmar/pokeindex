import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// pages
import './pages/pages.dart';

// providers
import './providers/providers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // setting prefered orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PokemonProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.indigo,
            centerTitle: true,
          ),
          primaryColor: Colors.indigo,
          textSelectionTheme: const TextSelectionThemeData(
            selectionHandleColor: Colors.indigoAccent,
          ),
          fontFamily: 'Capriola',
        ),
        home: const HomePage(),
      ),
    );
  }
}
