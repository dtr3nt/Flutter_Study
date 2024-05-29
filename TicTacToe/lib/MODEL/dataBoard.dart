class DataBoard {
//
  static const int TOP_LEFT = 2;
  static const int TOP_CENTER = 7;
  static const int TOP_RIGHT = 6;
//
  static const int MIDDLE_LEFT = 9;
  static const int MIDDLE_CENTER = 5;
  static const int MIDDLE_RIGHT = 1;
//
  static const int BOTTOM_LEFT = 4;
  static const int BOTTOM_CENTER = 3;
  static const int BOTTOM_RIGHT = 8;

  static List<int> possibleMoveSet = [
    MIDDLE_RIGHT,
    TOP_LEFT,
    BOTTOM_CENTER,
    BOTTOM_LEFT,
    MIDDLE_CENTER,
    TOP_RIGHT,
    TOP_CENTER,
    BOTTOM_RIGHT,
    MIDDLE_LEFT,
  ];
  //Drop Zone: X coordinate
  static const double LEFT = 63.0;
  static const double CENTER = 163.0;
  static const double RIGHT = 261.0;

  //Drop Zone: Y coordinate
  static const double TOP = 63.0;
  static const double MIDDLE = 163.0;
  static const double BOTTOM = 261.0;
}

// TOP ROW DROP ZONE DATA
class DropZoneTopLeft {
  static bool isFull = false;
  static bool dropX = false;
  static bool dropO = false;
}

class DropZoneTopCenter {
  static bool isFull = false;
  static bool dropX = false;
  static bool dropO = false;
}

class DropZoneTopRight {
  static bool isFull = false;
  static bool dropX = false;
  static bool dropO = false;
}

//MIDDLE ROW DROP ZONE DATA
class DropZoneMiddleLeft {
  static bool isFull = false;
  static bool dropX = false;
  static bool dropO = false;
}

class DropZoneMiddleCenter {
  static bool isFull = false;
  static bool dropX = false;
  static bool dropO = false;
}

class DropZoneMiddleRight {
  static bool isFull = false;
  static bool dropX = false;
  static bool dropO = false;
}

//BOTTOM ROW DROP ZONE DATA
class DropZoneBottomLeft {
  static bool isFull = false;
  static bool dropX = false;
  static bool dropO = false;
}

class DropZoneBottomCenter {
  static bool isFull = false;
  static bool dropX = false;
  static bool dropO = false;
}

class DropZoneBottomRight {
  static bool isFull = false;
  static bool dropX = false;
  static bool dropO = false;
}
