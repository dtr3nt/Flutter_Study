import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tictac/CONTROLLER/firebasecontroller.dart';
import 'package:tictac/CONTROLLER/gameController.dart';
import 'package:tictac/MODEL/dataBoard.dart';
import 'package:tictac/MODEL/dataO.dart';
import 'package:tictac/MODEL/dataX.dart';
import 'package:tictac/MODEL/fireGameData.dart';
import 'package:tictac/MODEL/gameConfig.dart';
import 'package:tictac/VIEW/mydialog.dart';

class TicTacToeScreen extends StatefulWidget {
  static const routeName = 'startScreen/gameOptionsScreen/ticTacToeScreen';
  @override
  State<StatefulWidget> createState() {
    return _TicTacToeScreenState();
  }
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  _Controller con;
  List<FireGameData> fireGameData;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  render(fn) async {
    setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Map arg = ModalRoute.of(context).settings.arguments;
    fireGameData ??= arg['fireGameData'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[600],
        title: Center(child: Text('Tic Tac Toe')),
        actions: <Widget>[
          RaisedButton.icon(
            onPressed: con.replay,
            icon: Icon(Icons.restore_sharp),
            label: Text('reset'),
            color: Colors.purple[600],
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            top: 10.0,
            left: 135.0,
            child: con.whosMove(),
          ),
          Positioned(
            top: 60.0,
            left: 60.0,
            child: Image.asset(
              'images/3x3alt.jpg',
              height: 300,
              fit: BoxFit.fitWidth,
            ),
          ),
// Positioned Grid of Drop Zones
          //DropZone Top Left
          Positioned(
            key: ValueKey(DataBoard.TOP_LEFT),
            top: DataBoard.TOP,
            left: DataBoard.LEFT,
            child: con.dropTargetGameAction(
              ValueKey(DataBoard.TOP_LEFT),
              DropZoneTopLeft.isFull,
              DropZoneTopLeft.dropX,
              DropZoneTopLeft.dropO,
            ),
          ),
          //DropZone Top Center
          Positioned(
            key: ValueKey(DataBoard.TOP_CENTER),
            top: DataBoard.TOP,
            left: DataBoard.CENTER,
            child: con.dropTargetGameAction(
              ValueKey(DataBoard.TOP_CENTER),
              DropZoneTopCenter.isFull,
              DropZoneTopCenter.dropX,
              DropZoneTopCenter.dropO,
            ),
          ),
          //DropZone Top Right
          Positioned(
            key: ValueKey(DataBoard.TOP_RIGHT),
            top: DataBoard.TOP,
            left: DataBoard.RIGHT,
            child: con.dropTargetGameAction(
              ValueKey(DataBoard.TOP_RIGHT),
              DropZoneTopRight.isFull,
              DropZoneTopRight.dropX,
              DropZoneTopRight.dropO,
            ),
          ),
          //DropZone Middle Left
          Positioned(
            key: ValueKey(DataBoard.MIDDLE_LEFT),
            top: DataBoard.MIDDLE,
            left: DataBoard.LEFT,
            child: con.dropTargetGameAction(
              ValueKey(DataBoard.MIDDLE_LEFT),
              DropZoneMiddleLeft.isFull,
              DropZoneMiddleLeft.dropX,
              DropZoneMiddleLeft.dropO,
            ),
          ),
          //DropZone Middle Center
          Positioned(
            key: ValueKey(DataBoard.MIDDLE_CENTER),
            top: DataBoard.MIDDLE,
            left: DataBoard.CENTER,
            child: con.dropTargetGameAction(
              ValueKey(DataBoard.MIDDLE_CENTER),
              DropZoneMiddleCenter.isFull,
              DropZoneMiddleCenter.dropX,
              DropZoneMiddleCenter.dropO,
            ),
          ),
          //DropZone Middle Right
          Positioned(
            key: ValueKey(DataBoard.MIDDLE_RIGHT),
            top: DataBoard.MIDDLE,
            left: DataBoard.RIGHT,
            child: con.dropTargetGameAction(
              ValueKey(DataBoard.MIDDLE_RIGHT),
              DropZoneMiddleRight.isFull,
              DropZoneMiddleRight.dropX,
              DropZoneMiddleRight.dropO,
            ),
          ),
          //DropZone Bottom Left
          Positioned(
            key: ValueKey(DataBoard.BOTTOM_LEFT),
            top: DataBoard.BOTTOM,
            left: DataBoard.LEFT,
            child: con.dropTargetGameAction(
              ValueKey(DataBoard.BOTTOM_LEFT),
              DropZoneBottomLeft.isFull,
              DropZoneBottomLeft.dropX,
              DropZoneBottomLeft.dropO,
            ),
          ),
          //DropZone Bottom Center
          Positioned(
            key: ValueKey(DataBoard.BOTTOM_CENTER),
            top: DataBoard.BOTTOM,
            left: DataBoard.CENTER,
            child: con.dropTargetGameAction(
              ValueKey(DataBoard.BOTTOM_CENTER),
              DropZoneBottomCenter.isFull,
              DropZoneBottomCenter.dropX,
              DropZoneBottomCenter.dropO,
            ),
          ),
          //DropZone Bottom Right
          Positioned(
            key: ValueKey(DataBoard.BOTTOM_RIGHT),
            top: DataBoard.BOTTOM,
            left: DataBoard.RIGHT,
            child: con.dropTargetGameAction(
              ValueKey(DataBoard.BOTTOM_RIGHT),
              DropZoneBottomRight.isFull,
              DropZoneBottomRight.dropX,
              DropZoneBottomRight.dropO,
            ),
          ),
          //Displaying User's X
          Positioned(
            top: 400.0,
            left: 60.0,
            child: new Draggable(
              maxSimultaneousDrags: 1,
              child: DataX.displayingX(),
              childWhenDragging: Container(),
              feedback: Opacity(opacity: 0.5, child: DataX.displayingX()),
              data: 'X',
            ),
          ),
          //Displaying User's O
          Positioned(
            top: 400.0,
            left: 280.0,
            child: new Draggable(
              maxSimultaneousDrags: 1,
              child: DataO.displayingO(),
              childWhenDragging: Container(),
              feedback: Opacity(opacity: 0.5, child: DataO.displayingO()),
              data: 'O',
            ),
          ),
          GameConfig.pvpONLINE
              ? Positioned(
                  top: 400,
                  left: 170,
                  child: IconButton(
                    icon: Icon(Icons.upgrade_outlined),
                    onPressed: con.submit,
                    iconSize: 70,
                    color: Colors.white,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

class _Controller {
  _TicTacToeScreenState _state;
  _Controller(this._state);
  bool swc = true;
  //
  void submit() async {
    // Get FireGameData
    List<FireGameData> download = await FirebaseController.getFireGameData();
    // Rebuild Screen
    GameController.resetBoard();
    DataX.setX.clear();
    DataO.setO.clear();
    DataBoard.possibleMoveSet.clear();
    DataBoard.possibleMoveSet = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    for (int i = 0; i < download[0].dataX.length; i++) {
      GameController.selectMoveX(download[0].dataX[i]);
      DataX.setX.add(download[0].dataX[i]);
      DataBoard.possibleMoveSet.remove(download[0].dataX[i]);
    }
    for (int i = 0; i < download[0].dataO.length; i++) {
      GameController.selectMoveO(download[0].dataO[i]);
      DataO.setO.add(download[0].dataO[i]);
      DataBoard.possibleMoveSet.remove(download[0].dataO[i]);
    }
    GameConfig.isXsTurn = download[0].isXturn;
    // Check for Win/Draw
    checkForWinners();
    checkForDraws();
    // Update _state
    _state.render(() {});
    //
  }

  //
  dropTargetGameAction(
    ValueKey valueKey,
    bool isFull,
    bool dropX,
    bool dropO,
  ) {
    int val = int.parse(valueKey.toString().substring(2, 3));
    return Container(
      height: 94.0,
      width: 94.0,
      color: Colors.black,
      child: DragTarget<String>(
        builder: (context, List<String> incoming, List rejected) {
          if (dropX == true && isFull == true) {
            return DataX.displayingX();
          } else if (dropO == true && isFull == true) {
            return DataO.displayingO();
          } else
            return null;
        },
        onWillAccept: (data) {
          if (isFull == true) {
            return false;
          } else {
            if (data == 'X' && GameConfig.isXsTurn == false) {
              return false;
            }
            if (data == 'O' && GameConfig.isXsTurn == true) {
              return false;
            }
            return true;
          }
        },
        onAccept: (data) async {
          if (GameConfig.pvp == true) {
            //Player Vs Player Game
            if (data == 'X') {
              // Player X Moves
              DataBoard.possibleMoveSet.remove(val);
              DataX.setX.add(val);
              GameController.selectMoveX(val);
              GameConfig.isXsTurn = false;
              checkForWinners();
              checkForDraws();
              _state.render(() {});
            } else if (data == 'O') {
              // Player O Moves
              DataBoard.possibleMoveSet.remove(val);
              DataO.setO.add(val);
              GameController.selectMoveO(val);
              GameConfig.isXsTurn = true;
              checkForWinners();
              checkForDraws();
              _state.render(() {});
            } else {
              print('PVP Error');
            }
          } else if (GameConfig.pve == true) {
            // Player Vs A.I.
            if (data == 'X') {
              DataBoard.possibleMoveSet.remove(val);
              DataX.setX.add(val);
              GameController.selectMoveX(val);
              GameConfig.isXsTurn = false;
              if (!GameController.checkWin(DataX.setX)) {
                if (GameConfig.playerX == true) {
                  if (DataBoard.possibleMoveSet.isNotEmpty) {
                    // AI MOVE
                    switch (GameConfig.aiDifficulty.round().toInt()) {
                      case 0:
                        GameController.selectMoveO(GameController.randomAImoveO(
                            DataBoard.possibleMoveSet));
                        break;
                      case 1:
                        GameController.selectMoveO(GameController.geniusMove(
                          DataBoard.possibleMoveSet,
                          DataO.setO,
                          DataX.setX,
                        ));
                        break;
                      default:
                        print('AI Switch error');
                        break;
                    }
                    // Swap Player turn
                    GameConfig.isXsTurn = true;
                  }
                }
              }
              _state.render(() {});
            } else if (data == 'O') {
              DataBoard.possibleMoveSet.remove(val);
              DataO.setO.add(val);
              GameController.selectMoveO(val);
              GameConfig.isXsTurn = true;
              if (!GameController.checkWin(DataO.setO)) {
                if (GameConfig.playerX == false) {
                  if (DataBoard.possibleMoveSet.isNotEmpty) {
                    // AI MOVE
                    GameController.selectMoveX(GameController.randomAImoveX(
                        DataBoard.possibleMoveSet));
                    // Swap Player turn
                    GameConfig.isXsTurn = false;
                  }
                }
              }
              checkForWinners();
              checkForDraws();
              _state.render(() {});
            } else {
              print('PVE Error');
            }
          } else if (GameConfig.pvpONLINE) {
            // Player Vs. Player ONLINE
            if (data == 'X') {
              // Player X makes move
              DataBoard.possibleMoveSet.remove(val);
              DataX.setX.add(val);
              GameController.selectMoveX(val);
              GameConfig.isXsTurn = false;
              // upload FireGameData
              var upload = FireGameData(
                docId: _state.fireGameData.last.docId,
                dataX: DataX.setX,
                dataO: DataO.setO,
                movesLeft: DataBoard.possibleMoveSet,
                isXturn: GameConfig.isXsTurn,
              );
              await FirebaseController.updateFireGameData(upload, upload.docId);
              // Check for Win/Draw
              checkForWinners();
              checkForDraws();
              // Update _state
              _state.render(() {});
              //
            } else if (data == 'O') {
              // Player O makes move
              DataBoard.possibleMoveSet.remove(val);
              DataO.setO.add(val);
              GameConfig.isXsTurn = true;
              GameController.selectMoveO(val);
              // update FireGameData
              var update = FireGameData(
                docId: _state.fireGameData.last.docId,
                dataO: DataO.setO,
                dataX: DataX.setX,
                movesLeft: DataBoard.possibleMoveSet,
                isXturn: GameConfig.isXsTurn,
              );
              await FirebaseController.updateFireGameData(update, update.docId);
              // Check for Win/Draw
              checkForWinners();
              checkForDraws();
              // Update _state
              _state.render(() {});
              //
            } else {
              print('PVPonline data error');
            }
          } else {
            print('Game Error');
          }
        },
      ),
    );
  }

  //
  void checkForWinners() {
    if (GameController.checkWin(DataX.setX)) winnerAlert('Player X Wins');
    if (GameController.checkWin(DataO.setO)) winnerAlert('Player O Wins');
  }

  //
  void checkForDraws() {
    if (DataBoard.possibleMoveSet.isEmpty) {
      if (!GameController.checkWin(DataX.setX) &&
          !GameController.checkWin(DataO.setO)) {
        drawAlert('Cat Scratch');
      }
    }
  }

  //
  drawAlert(String message) {
    Alert(
      context: _state.context,
      title: "DRAW",
      content: Text(message),
      buttons: [
        DialogButton(
          child: Text(
            'Replay',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: () {
            replay();
            Navigator.pop(_state.context);
          },
          color: Colors.purple[600],
        ),
      ],
    ).show();
  }

  //
  Future<void> delay(int val) async {
    await Future.delayed(Duration(milliseconds: val));
  }

  //
  void replay() {
    DataX.setX.clear();
    DataO.setO.clear();
    DataBoard.possibleMoveSet = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    GameController.resetBoard();
    GameConfig.isXsTurn = true;
    if (GameConfig.pve == true && GameConfig.playerX == false) {
      GameController.aiFirstMoveX();
    }
    if (GameConfig.aiVSai) {
      aiVSai();
    }
    _state.render(() {});
  }

  //
  Widget whosMove() {
    if (GameConfig.pvp || GameConfig.pve) {
      if (GameConfig.isXsTurn) {
        return Text(
          'X to Move',
          style: TextStyle(color: Colors.red, fontSize: 30.0),
        );
      } else {
        return Text(
          'O to Move',
          style: TextStyle(color: Colors.green, fontSize: 30.0),
        );
      }
    } else if (GameConfig.aiVSai) {
      if (swc) {
        aiVSai();
        swc = false;
      }
      return Text(
        'A.I. is Thinking',
        style: TextStyle(color: Colors.purple, fontSize: 30.0),
      );
    } else if (GameConfig.pvpONLINE) {
      if (GameConfig.playerX) {
        if (GameConfig.isXsTurn) {
          return Text(
            'X to Move',
            style: TextStyle(color: Colors.red, fontSize: 30.0),
          );
        } else {
          return Text(
            'Waiting on O',
            style: TextStyle(color: Colors.green, fontSize: 30.0),
          );
        }
      } else {
        if (GameConfig.isXsTurn) {
          return Text(
            'Waiting on X',
            style: TextStyle(color: Colors.red, fontSize: 30.0),
          );
        } else {
          print('test');
          return Text(
            'O to Move',
            style: TextStyle(color: Colors.green, fontSize: 30.0),
          );
        }
      }
    }
  }

  //
  aiVSai() async {
    bool gameInProgress = true;
    while (gameInProgress) {
      if (DataBoard.possibleMoveSet.isNotEmpty) {
        if (GameConfig.isXsTurn) {
          // AI MOVE
          GameController.selectMoveX(
              GameController.randomAImoveX(DataBoard.possibleMoveSet));
          //

          GameConfig.isXsTurn = false;
        } else if (!GameConfig.isXsTurn) {
          // AI MOVE
          GameController.selectMoveO(
              GameController.randomAImoveO(DataBoard.possibleMoveSet));
          //

          GameConfig.isXsTurn = true;
        } else {}

        // Check for Winner
        if (GameController.checkWin(DataX.setX)) {
          gameInProgress = false;
          winnerAlert('Player X Wins');
        }
        if (GameController.checkWin(DataO.setO)) {
          gameInProgress = false;
          winnerAlert('Player O Wins');
        }

        // Check for Draw
        if (DataBoard.possibleMoveSet.isEmpty) {
          if (!GameController.checkWin(DataX.setX) &&
              !GameController.checkWin(DataO.setO)) {
            gameInProgress = false;
            drawAlert('Cat Scratch');
          }
        }
      }
      await delay(GameController.randomDelaySeed());
      _state.render(() {});
    }
  }

  //
  winnerAlert(String message) {
    Alert(
      context: _state.context,
      title: "WINNER",
      content: Text(message),
      buttons: [
        DialogButton(
          child: Text(
            'Replay',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: () {
            replay();
            Navigator.pop(_state.context);
          },
          color: Colors.purple[600],
        ),
      ],
    ).show();
  }
  //
}
