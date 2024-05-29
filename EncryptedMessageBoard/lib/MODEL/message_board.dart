class MessageBoard {
  // field name for Firestore documents
  static const COLLECTION = 'messageBoard';
  static const DATEPUBLISH = 'datePublished';
  static const AUTHOR = 'author';
  static const MESSAGE = 'message';

  String docId; //Firestore doc id
  DateTime datePublished;
  String author;
  String message;

  MessageBoard({
    this.docId,
    this.datePublished,
    this.author,
    this.message,
  });

  //convert Dart object to Firestore document
  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      DATEPUBLISH: datePublished,
      AUTHOR: author,
      MESSAGE: message,
    };
  }

  //convert Firestore document to Dart object
  static MessageBoard deserialize(Map<String, dynamic> data, String docId) {
    return MessageBoard(
      docId: docId,
      author: data[MessageBoard.AUTHOR],
      message: data[MessageBoard.MESSAGE],
      datePublished: data[MessageBoard.DATEPUBLISH] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              data[MessageBoard.DATEPUBLISH].millisecondsSinceEpoch,
            )
          : null,
    );
  }

  @override
  String toString() {
    return '$docId $author $message \n';
  }
}
