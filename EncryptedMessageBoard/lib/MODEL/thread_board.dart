class ThreadBoard {
  // field name for Firestore documents
  static const COLLECTION = 'threadBoard';
  static const DATECREATED = 'dateCreated';
  static const THREADBY = 'threadBy';
  static const THREADTITLE = 'threadTitle';
  static const THREADMESSAGE = 'threadMessage';

  String docId; //Firestore doc id
  DateTime dateCreated;
  String threadBy;
  String threadTitle;
  String threadMessage;

  ThreadBoard({
    this.docId,
    this.dateCreated,
    this.threadBy,
    this.threadTitle,
    this.threadMessage,
  });

  //convert Dart object to Firestore document
  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      DATECREATED: dateCreated,
      THREADBY: threadBy,
      THREADTITLE: threadTitle,
      THREADMESSAGE: threadMessage,
    };
  }

  //convert Firestore document to Dart object
  static ThreadBoard deserialize(Map<String, dynamic> data, String docId) {
    return ThreadBoard(
      docId: docId,
      threadBy: data[ThreadBoard.THREADBY],
      threadTitle: data[ThreadBoard.THREADTITLE],
      threadMessage: data[ThreadBoard.THREADMESSAGE],
      dateCreated: data[ThreadBoard.DATECREATED] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              data[ThreadBoard.DATECREATED].millisecondsSinceEpoch,
            )
          : null,
    );
  }

  @override
  String toString() {
    return '$docId';
  }
}
