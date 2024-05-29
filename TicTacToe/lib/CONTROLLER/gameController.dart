import 'dart:math';
import 'package:tictac/MODEL/dataBoard.dart';
import 'package:tictac/MODEL/dataO.dart';
import 'package:tictac/MODEL/dataX.dart';
import 'package:tictac/MODEL/gameConfig.dart';

class GameController {
  static bool checkWin(List plays) {
    int i = 0;
    int j = 1;
    int k = 2;
    int ck;
    int win = 15;
    if (plays.length >= 3) {
      while (i < plays.length - 2) {
        while (j < plays.length - 1) {
          while (k < plays.length) {
            ck = (plays[i] + plays[j] + plays[k]);
            if (ck == win) {
              return true;
            } else {
              k++;
            }
          }
          j++;
          k = j + 1;
        }
        i++;
        j = i + 1;
        k = j + 1;
      }
    }
    return false;
  }

  static int minimax(
    move,
    depth,
    isMaximizing,
    movesLeft,
    aiMoveSet,
    humanMoveSet,
  ) {
    humanMoveSet.sort();
    aiMoveSet.sort();
    if (checkWin(humanMoveSet)) {
      return -1;
    } else if (checkWin(aiMoveSet)) {
      return 1;
    } else if (movesLeft.isEmpty) {
      if (!checkWin(aiMoveSet) && !checkWin(humanMoveSet)) {
        return 0;
      }
    }
    if (isMaximizing) {
      int bestScore = -100;
      for (int i = 0; i < movesLeft.length; i++) {
        int move = movesLeft[i];
        movesLeft.remove(move);
        aiMoveSet.add(move);
        int score = minimax(
          move,
          depth + 1,
          false,
          movesLeft,
          aiMoveSet,
          humanMoveSet,
        );
        movesLeft.add(move);
        aiMoveSet.remove(move);
        if (score == 0) {
          bestScore = score;
          if (score == 1) {
            bestScore = score;
          }
        }
      }
      return bestScore;
    } else {
      int bestScore = 100;
      for (int i = 0; i < movesLeft.length; i++) {
        int move = movesLeft[i];
        humanMoveSet.add(move);
        movesLeft.remove(move);
        int score = minimax(
          move,
          depth + 1,
          true,
          movesLeft,
          aiMoveSet,
          humanMoveSet,
        );
        movesLeft.add(move);
        humanMoveSet.remove(move);
        if (score == 0) {
          bestScore = score;
          if (score == -1) {
            bestScore = score;
          }
        }
      }
      return bestScore;
    }
  }

  static int geniusMove(
      List<int> movesLeft, List<int> aiMoveSet, List<int> humanMoveSet) {
    int move;
    int bestScore = -100;
    int bestMove;
    for (int i = 0; i < movesLeft.length; i++) {
      move = movesLeft[i];
      aiMoveSet.add(move);
      movesLeft.remove(move);
      print("***************");
      print('MoveSet');
      int score = minimax(
        move,
        0,
        false,
        movesLeft,
        aiMoveSet,
        humanMoveSet,
      );
      print('Move : $move');
      print('Score: $score');
      print('+++++++++++++++++');
      if (score > bestScore) {
        bestScore = score;
        bestMove = move;
      }
      aiMoveSet.remove(move);
      movesLeft.add(move);
    }
    print(bestMove);
    return bestMove;
  }

  static void aiFirstMoveX() {
    switch (GameConfig.aiDifficulty.round().toInt()) {
      case 0:
        selectMoveX(randomAImoveX(DataBoard.possibleMoveSet));
        GameConfig.isXsTurn = false;
        break;
      case 1:
        selectMoveX(5);
        GameConfig.isXsTurn = false;
        break;
      case 2:
        selectMoveX(5);
        GameConfig.isXsTurn = false;
        break;
      default:
        print('aiFirstMoveX Error');
    }
  }

  static int randomDelaySeed() {
    Random random = new Random();
    return random.nextInt(500) + 1550;
  }

  static int randomAImoveO(List<int> moveSet) {
    Random random = new Random();
    int result;
    result = moveSet.elementAt(random.nextInt(moveSet.length));
    DataBoard.possibleMoveSet.remove(result);
    DataO.setO.add(result);
    return result;
  }

  static int randomAImoveX(List<int> moveSet) {
    Random random = new Random();
    int result;
    result = moveSet.elementAt(random.nextInt(moveSet.length));
    DataBoard.possibleMoveSet.remove(result);
    DataX.setX.add(result);
    return result;
  }

  static void selectMoveO(int val) {
    switch (val) {
      case 2:
        DropZoneTopLeft.isFull = true;
        DropZoneTopLeft.dropO = true;
        //AImove
        break;
      case 7:
        DropZoneTopCenter.isFull = true;
        DropZoneTopCenter.dropO = true;
        //AImove
        break;
      case 6:
        DropZoneTopRight.isFull = true;
        DropZoneTopRight.dropO = true;
        //AImove
        break;
      case 9:
        DropZoneMiddleLeft.isFull = true;
        DropZoneMiddleLeft.dropO = true;
        //AImove
        break;
      case 5:
        DropZoneMiddleCenter.isFull = true;
        DropZoneMiddleCenter.dropO = true;
        //AImove
        break;
      case 1:
        DropZoneMiddleRight.isFull = true;
        DropZoneMiddleRight.dropO = true;
        //AImove
        break;
      case 4:
        DropZoneBottomLeft.isFull = true;
        DropZoneBottomLeft.dropO = true;
        //AImove
        break;
      case 3:
        DropZoneBottomCenter.isFull = true;
        DropZoneBottomCenter.dropO = true;
        //AImove
        break;
      case 8:
        DropZoneBottomRight.isFull = true;
        DropZoneBottomRight.dropO = true;
        //AImove
        break;
    }
  }

  static void selectMoveX(int val) {
    switch (val) {
      case 2:
        DropZoneTopLeft.isFull = true;
        DropZoneTopLeft.dropX = true;
        //AImove
        break;
      case 7:
        DropZoneTopCenter.isFull = true;
        DropZoneTopCenter.dropX = true;
        //AImove
        break;
      case 6:
        DropZoneTopRight.isFull = true;
        DropZoneTopRight.dropX = true;
        //AImove
        break;
      case 9:
        DropZoneMiddleLeft.isFull = true;
        DropZoneMiddleLeft.dropX = true;
        //AImove
        break;
      case 5:
        DropZoneMiddleCenter.isFull = true;
        DropZoneMiddleCenter.dropX = true;
        //AImove
        break;
      case 1:
        DropZoneMiddleRight.isFull = true;
        DropZoneMiddleRight.dropX = true;
        //AImove
        break;
      case 4:
        DropZoneBottomLeft.isFull = true;
        DropZoneBottomLeft.dropX = true;
        //AImove
        break;
      case 3:
        DropZoneBottomCenter.isFull = true;
        DropZoneBottomCenter.dropX = true;
        //AImove
        break;
      case 8:
        DropZoneBottomRight.isFull = true;
        DropZoneBottomRight.dropX = true;
        //AImove
        break;
    }
  }

  static void resetBoard() {
    //TOP ROW
    DropZoneTopLeft.isFull = false;
    DropZoneTopLeft.dropO = false;
    DropZoneTopLeft.dropX = false;

    DropZoneTopCenter.isFull = false;
    DropZoneTopCenter.dropO = false;
    DropZoneTopCenter.dropX = false;

    DropZoneTopRight.isFull = false;
    DropZoneTopRight.dropO = false;
    DropZoneTopRight.dropX = false;

    //MIDDLE ROW
    DropZoneMiddleLeft.isFull = false;
    DropZoneMiddleLeft.dropO = false;
    DropZoneMiddleLeft.dropX = false;

    DropZoneMiddleCenter.isFull = false;
    DropZoneMiddleCenter.dropO = false;
    DropZoneMiddleCenter.dropX = false;

    DropZoneMiddleRight.isFull = false;
    DropZoneMiddleRight.dropO = false;
    DropZoneMiddleRight.dropX = false;

    //BOTTOM ROW
    DropZoneBottomLeft.isFull = false;
    DropZoneBottomLeft.dropO = false;
    DropZoneBottomLeft.dropX = false;

    DropZoneBottomCenter.isFull = false;
    DropZoneBottomCenter.dropO = false;
    DropZoneBottomCenter.dropX = false;

    DropZoneBottomRight.isFull = false;
    DropZoneBottomRight.dropO = false;
    DropZoneBottomRight.dropX = false;
  }
}
