import 'package:flutter/material.dart';
import 'package:tictac/CONTROLLER/firebasecontroller.dart';
import 'package:tictac/CONTROLLER/gameController.dart';
import 'package:tictac/MODEL/dataBoard.dart';
import 'package:tictac/MODEL/dataO.dart';
import 'package:tictac/MODEL/dataX.dart';
import 'package:tictac/MODEL/fireGameData.dart';
import 'package:tictac/MODEL/gameConfig.dart';
import 'package:tictac/VIEW/tictactoe_screen.dart';

class GameOptionsScreen extends StatefulWidget {
  static const routeName = 'startScreen/gameOptionsScreen';
  @override
  State<StatefulWidget> createState() {
    return _GameOptionsScreenState();
  }
}

class _GameOptionsScreenState extends State<GameOptionsScreen> {
  _Controller con;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  render(fn) {
    setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
              'Game Options',
              style: TextStyle(
                fontSize: 50,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 3
                  ..color = Colors.white,
              ),
            ),
          ),
          Positioned(
            top: 80,
            left: 95,
            child: Column(
              children: <Widget>[
                Text(
                  'Player vs Player',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
                RaisedButton(
                  child: Text('Start'),
                  color: Colors.blue,
                  onPressed: con.configPVP,
                ),
                Text(
                  'Player vs A.I.',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: <Widget>[
                    RaisedButton(
                      child: Text('Play as X'),
                      color: Colors.blue,
                      onPressed: () {
                        GameConfig.playerX = true;
                        GameConfig.isXsTurn = true;
                        con.configPVE();
                      },
                    ),
                    SizedBox(width: 10.0),
                    RaisedButton(
                      child: Text('Play as O'),
                      color: Colors.blue,
                      onPressed: () {
                        GameConfig.playerX = false;
                        GameConfig.isXsTurn = false;
                        con.configPVE();
                        GameController.aiFirstMoveX();
                      },
                    ),
                  ],
                ),
                Text(
                  'A.I. vs A.I.',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
                RaisedButton(
                  child: Text('Watch'),
                  color: Colors.blue,
                  onPressed: con.configEVE,
                ),
                Text(
                  'A.I. Difficulty',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
                Slider(
                  value: GameConfig.aiDifficulty,
                  min: 0.0,
                  max: 1.0,
                  divisions: 1,
                  label: con.labelAI(GameConfig.aiDifficulty.round().toInt()),
                  onChanged: (val) {
                    GameConfig.aiDifficulty = val;
                    render(() {});
                  },
                ),
                Text(
                  'Player vs Player Online',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: <Widget>[
                    RaisedButton(
                      child: Text('Play as X'),
                      color: Colors.blue,
                      onPressed: () {
                        GameConfig.playerX = true;
                        GameConfig.isXsTurn = true;
                        con.playOnline();
                      },
                    ),
                    SizedBox(width: 10.0),
                    RaisedButton(
                      child: Text('Play as O'),
                      color: Colors.blue,
                      onPressed: () {
                        GameConfig.playerX = false;
                        GameConfig.isXsTurn = false;
                        con.playOnline();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Controller {
  _GameOptionsScreenState _state;
  _Controller(this._state);

  void configEVE() {
    DataX.setX.clear();
    DataO.setO.clear();
    DataBoard.possibleMoveSet = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    GameController.resetBoard();
    GameConfig.aiVSai = true;
    GameConfig.pvp = false;
    GameConfig.pve = false;
    GameConfig.pvpONLINE = false;
    List<FireGameData> fireGameData = [];
    _state.render(() {});
    Navigator.pushNamed(_state.context, TicTacToeScreen.routeName,
        arguments: {'fireGameData': fireGameData});
  }

  void configPVP() {
    DataX.setX.clear();
    DataO.setO.clear();
    DataBoard.possibleMoveSet = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    GameController.resetBoard();
    GameConfig.isXsTurn = true;
    GameConfig.aiVSai = false;
    GameConfig.pvp = true;
    GameConfig.pve = false;
    GameConfig.pvpONLINE = false;
    List<FireGameData> fireGameData = [];
    _state.render(() {});
    Navigator.pushNamed(_state.context, TicTacToeScreen.routeName,
        arguments: {'fireGameData': fireGameData});
  }

  void configPVE() {
    DataX.setX.clear();
    DataO.setO.clear();
    DataBoard.possibleMoveSet = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    GameController.resetBoard();
    GameConfig.aiVSai = false;
    GameConfig.pvp = false;
    GameConfig.pve = true;
    GameConfig.pvpONLINE = false;
    List<FireGameData> fireGameData = [];
    _state.render(() {});
    Navigator.pushNamed(_state.context, TicTacToeScreen.routeName,
        arguments: {'fireGameData': fireGameData});
  }

  void playOnline() async {
    DataX.setX.clear();
    DataO.setO.clear();
    DataBoard.possibleMoveSet = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    GameController.resetBoard();
    GameConfig.aiVSai = false;
    GameConfig.pvp = false;
    GameConfig.pve = false;
    GameConfig.pvpONLINE = true;
    //
    try {
      // setup Board
      var setup = FireGameData(
        docId: 'testing',
        dataX: DataX.setX,
        dataO: DataO.setO,
        movesLeft: DataBoard.possibleMoveSet,
        isXturn: GameConfig.isXsTurn,
      );
      await FirebaseController.updateFireGameData(setup, setup.docId);
      List<FireGameData> fireGameData =
          await FirebaseController.getFireGameData();
      //
      Navigator.pushNamed(_state.context, TicTacToeScreen.routeName,
          arguments: {'fireGameData': fireGameData});
      _state.render(() {});
      //
    } catch (e) {
      print(e.toString());
    }
    //
  }

  String labelAI(int val) {
    switch (val) {
      case 0:
        return 'Dumb';
        break;
      case 1:
        return 'Smart';
        break;
      default:
        return 'Error';
    }
  }
}
