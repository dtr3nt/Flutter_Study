import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tictac/VIEW/tictactoe_screen.dart';
import 'package:tictac/VIEW/gameoptions_screen.dart';
import 'package:tictac/VIEW/startscreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(TicTac());
}

class TicTac extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: StartScreen.routeName,
      routes: {
        StartScreen.routeName: (context) => StartScreen(),
        GameOptionsScreen.routeName: (context) => GameOptionsScreen(),
        TicTacToeScreen.routeName: (context) => TicTacToeScreen(),
      },
    );
  }
}
