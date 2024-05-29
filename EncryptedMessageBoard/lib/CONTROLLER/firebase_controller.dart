import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hush/MODEL/message_board.dart';
import 'package:hush/MODEL/reply_board.dart';
import 'package:hush/MODEL/thread_board.dart';
import 'package:hush/VIEW/mydialog.dart';

class FirebaseController {
  //SIGN IN AND SIGN OUT FUNCTIONS
  static Future signIn(String email, String password) async {
    UserCredential auth =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return auth.user;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  //
  // THREADS
  //
  static Future<List<ThreadBoard>> getThreads() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(ThreadBoard.COLLECTION)
        .get();
    var result = <ThreadBoard>[];
    if (querySnapshot != null && querySnapshot.docs.length != 0) {
      for (var doc in querySnapshot.docs) {
        result.add(ThreadBoard.deserialize(doc.data(), doc.id));
      }
    }
    return result;
  }

  static Future<List<ThreadBoard>> getMyThreads(String author) async {
    QuerySnapshot querySnapShot = await FirebaseFirestore.instance
        .collection(ThreadBoard.COLLECTION)
        .where(ThreadBoard.THREADBY, isEqualTo: author)
        .orderBy(ThreadBoard.DATECREATED, descending: true)
        .get();
    var result = <ThreadBoard>[];
    if (querySnapShot != null && querySnapShot.docs.length != 0) {
      for (var doc in querySnapShot.docs) {
        result.add(ThreadBoard.deserialize(doc.data(), doc.id));
      }
    }
    return result;
  }

  static Future<String> publishThread(ThreadBoard thread) async {
    thread.dateCreated = DateTime.now();

    DocumentReference ref = await FirebaseFirestore.instance
        .collection(ThreadBoard.COLLECTION)
        .add(thread.serialize());
    return ref.id;
  }

  static Future<void> deleteThread(ThreadBoard thread) async {
    await FirebaseFirestore.instance
        .collection(ThreadBoard.COLLECTION)
        .doc(thread.docId)
        .delete();
  }

  //
  // MESSAGES
  //

  static Future<void> deleteMessage(MessageBoard message) async {
    await FirebaseFirestore.instance
        .collection(MessageBoard.COLLECTION)
        .doc(message.docId)
        .delete();
  }

  static Future<String> publishMessage(
    ThreadBoard thread,
    MessageBoard message,
  ) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(ThreadBoard.COLLECTION)
        .doc(thread.docId)
        .collection(MessageBoard.COLLECTION)
        .add(message.serialize());
    return ref.id;
  }

  static Future<List<MessageBoard>> getMessages(ThreadBoard thread) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(ThreadBoard.COLLECTION)
        .doc(thread.docId)
        .collection(MessageBoard.COLLECTION)
        .get();
    var result = <MessageBoard>[];
    if (querySnapshot != null && querySnapshot.docs.length != 0) {
      for (var doc in querySnapshot.docs) {
        result.add(MessageBoard.deserialize(doc.data(), doc.id));
      }
    }
    return result;
  }

  //
  // REPLIES
  //

  static Future<void> deleteReply(ReplyBoard reply) async {
    await FirebaseFirestore.instance
        .collection(MessageBoard.COLLECTION)
        .doc(reply.docId)
        .delete();
  }

  static Future<String> publishReply(
    ThreadBoard thread,
    String docId,
    ReplyBoard reply,
  ) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(ThreadBoard.COLLECTION)
        .doc(thread.docId)
        .collection(MessageBoard.COLLECTION)
        .doc(docId)
        .collection(ReplyBoard.COLLECTION)
        .add(reply.serialize());
    return ref.id;
  }

  static Future<List<ReplyBoard>> getReplies(
    ThreadBoard thread,
    String docId,
  ) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(ThreadBoard.COLLECTION)
        .doc(thread.docId)
        .collection(MessageBoard.COLLECTION)
        .doc(docId)
        .collection(ReplyBoard.COLLECTION)
        .get();
    var result = <ReplyBoard>[];
    if (querySnapshot != null && querySnapshot.docs.length != 0) {
      for (var doc in querySnapshot.docs) {
        result.add(ReplyBoard.deserialize(doc.data(), doc.id));
      }
    }
    return result;
  }
}
