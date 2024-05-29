class GameConfig {
  static bool pvp = false;
  static bool pvpONLINE = false;
  static bool pve = false;
  static bool aiVSai = false;
  static bool playerX = false;
  static bool isXsTurn = false;
  static double aiDifficulty = 0.0;

  static resetGameConfig() {
    pvp = false;
    pvpONLINE = false;
    pve = false;
    aiVSai = false;
    playerX = false;
    isXsTurn = false;
  }
}
