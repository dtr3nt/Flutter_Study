import 'package:flutter/material.dart';
import 'package:tictac/VIEW/gameoptions_screen.dart';

class StartScreen extends StatelessWidget {
  static const routeName = '/startScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[600],
        title: Center(child: Text('Main Screen')),
      ),
      body: Stack(
        children: <Widget>[
          Image.asset(
            'images/MainBackground.jpg',
            height: 900,
            fit: BoxFit.fitHeight,
          ),
          Positioned(
            left: 50,
            child: Text(
              'Tic Tac Toe',
              style: TextStyle(
                fontSize: 60,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 3
                  ..color = Colors.white,
              ),
            ),
          ),
          Positioned(
            top: 275,
            left: 125,
            child: RaisedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, GameOptionsScreen.routeName),
              child: Text('Cool Cube Graphic'),
            ),
          ),
        ],
      ),
    );
  }
}
