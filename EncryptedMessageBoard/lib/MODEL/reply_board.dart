class ReplyBoard {
  // field name for Firestore documents
  static const COLLECTION = 'ReplyBoard';
  static const DATEPUBLISH = 'datePublished';
  static const AUTHOR = 'author';
  static const REPLY = 'reply';

  String docId; //Firestore doc id
  DateTime datePublished;
  String author;
  String reply;

  ReplyBoard({
    this.docId,
    this.datePublished,
    this.author,
    this.reply,
  });

  //convert Dart object to Firestore document
  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      DATEPUBLISH: datePublished,
      AUTHOR: author,
      REPLY: reply,
    };
  }

  //convert Firestore document to Dart object
  static ReplyBoard deserialize(Map<String, dynamic> data, String docId) {
    return ReplyBoard(
      docId: docId,
      author: data[ReplyBoard.AUTHOR],
      reply: data[ReplyBoard.REPLY],
      datePublished: data[ReplyBoard.DATEPUBLISH] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              data[ReplyBoard.DATEPUBLISH].millisecondsSinceEpoch,
            )
          : null,
    );
  }

  @override
  String toString() {
    return '$docId $author $reply \n';
  }
}
