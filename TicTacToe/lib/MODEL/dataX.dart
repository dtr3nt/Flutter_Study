import 'package:flutter/material.dart';

class DataX {
  static List<int> setX = List();

  static Widget displayingX() {
    return Image.asset(
      'images/NeonRedX.png',
      height: 100,
      fit: BoxFit.fitWidth,
    );
  }

  // static Map<String, List<int>> winSetX = {
  //   'a0-a2': [2, 7, 6],
  //   'b0-b2': [9, 5, 1],
  //   'c0-c2': [4, 3, 8],
  //   'a0-c0': [2, 9, 4],
  //   'a1-c1': [7, 5, 3],
  //   'a2-c2': [6, 1, 8],
  //   'a0-c2': [2, 5, 8],
  //   'c0-a2': [4, 5, 6],
  // };
}
