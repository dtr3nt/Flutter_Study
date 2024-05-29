class FireGameData {
  static const COLLECTION = 'matches';
  static const DATAX = 'DataX';
  static const DATAO = 'DataO';
  static const MOVESLEFT = 'MovesLeft';
  static const ISXTURN = 'isXturn';

  String docId = 'testing';
  List<dynamic> dataX;
  List<dynamic> dataO;
  List<dynamic> movesLeft;
  bool isXturn;

  FireGameData({
    this.docId,
    this.dataX,
    this.dataO,
    this.movesLeft,
    this.isXturn,
  }) {
    this.dataX ??= [];
    this.dataO ??= [];
    this.movesLeft ??= [];
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      DATAX: dataX,
      DATAO: dataO,
      MOVESLEFT: movesLeft,
      ISXTURN: isXturn,
    };
  }

  static FireGameData deserialized(Map<String, dynamic> data, String docId) {
    return FireGameData(
      docId: docId,
      dataX: data[FireGameData.DATAX],
      dataO: data[FireGameData.DATAO],
      movesLeft: data[FireGameData.MOVESLEFT],
      isXturn: data[FireGameData.ISXTURN],
    );
  }

  @override
  String toString() {
    return 'DocId : $docId \n DataX : $dataX \n DataO : $dataO \n MovesLeft: $movesLeft \n isXturn: $isXturn \n';
  }
}
