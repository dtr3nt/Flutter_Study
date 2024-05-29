import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hush/CONTROLLER/firebase_controller.dart';
import 'package:hush/MODEL/message_board.dart';
import 'package:hush/MODEL/reply_board.dart';
import 'package:hush/MODEL/thread_board.dart';
import 'package:hush/VIEW/addreply_screen.dart';
import 'package:hush/VIEW/mydialog.dart';

class ReplyBoardScreen extends StatefulWidget {
  static const routeName = '/threadBoardScreen/messageBoardScreen/replyScreen';

  @override
  State<StatefulWidget> createState() {
    return _ReplyBoardState();
  }
}

class _ReplyBoardState extends State<ReplyBoardScreen> {
  //
  User user;
  ThreadBoard thread;
  String decryptmsg;
  String msgDocid;
  List<ReplyBoard> replies;
  var formKey = GlobalKey<FormState>();
  String decryptreply = 'x';

  //
  _Controller con;
  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  //
  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    user ??= args['user'];
    thread ??= args['thread'];
    decryptmsg ??= args['message'];
    msgDocid ??= args['msgDocid'];
    replies ??= args['replies'];
    decryptreply ??= args['decrypted reply'];

    return Scaffold(
      appBar: AppBar(
        title: Text('CHAT'),
        titleSpacing: 2.0,
        actions: <Widget>[
          con.delIndex == null
              ? Row(
                  children: [
                    Container(
                      width: 235.0,
                      child: Form(
                        key: formKey,
                        child: TextFormField(
                          decoration: InputDecoration(
                            fillColor: Colors.grey[50],
                            hintText: 'passKey',
                            filled: true,
                          ),
                          autocorrect: false,
                          onSaved: con.onSavedPassCode,
                        ),
                      ),
                    ),
                  ],
                )
              : IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: con.delete,
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: con.addReply,
      ),
      body: ListView(
        children: <Widget>[
          Card(
            child: Text(
              decryptmsg,
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            margin: EdgeInsets.all(10.0),
            elevation: 10.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          decryptreply.length == 1
              ? Text('no decrypted reply')
              : Card(
                  child: Text(
                    decryptreply,
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  margin: EdgeInsets.all(10.0),
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
          replies.length == 0
              ? Text('No replies')
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: replies.length,
                  itemBuilder: (BuildContext context, int index) => Card(
                    color: con.delIndex != null && con.delIndex == index
                        ? Colors.red[100]
                        : Colors.white,
                    margin: EdgeInsets.all(10.0),
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      onLongPress: () => con.onLongPress(index),
                      onTap: () => con.onTap(index),
                      title: Text(replies[index].reply),
                      subtitle: Column(
                        children: <Widget>[
                          Text('Author: ${replies[index].author}'),
                          Text('Date: ${replies[index].datePublished}'),
                        ],
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

class _Controller {
  _ReplyBoardState _state;
  _Controller(this._state);
  int delIndex;
  String passkey;
  List<String> messageTOListStr;
  List<int> listStrTOListInt = List<int>();

  void onTap(int index) async {
    // Vaildate Form
    if (!_state.formKey.currentState.validate()) {
      return;
    }
    _state.formKey.currentState.save();
    // Divide Message: String into List of Strings
    messageTOListStr = _state.replies[index].reply.split(',').toList();
    // Convert Message: List of Strings into List of Ints
    for (int k = 0; k < messageTOListStr.length; k++) {
      listStrTOListInt.add(int.parse(
          messageTOListStr[k].replaceAll(']', '').replaceAll('[', '').trim()));
    }
    // Convert Passkey: String into List of Ints
    List<int> rawPassCode = passkey.codeUnits;
    // Create Space for Decrypted List of Ints
    List<int> rawDecrypted = List<int>();
    // DECRYPT DATA: Decrypted List into a Decrypted String
    int i = 0;
    int j = 0;
    for (i = 0; i < listStrTOListInt.length;) {
      for (j = 0; j < rawPassCode.length; j++) {
        rawDecrypted.add(rawPassCode[j] ^ listStrTOListInt[i]);
        i++;
        if (i >= listStrTOListInt.length) break;
      }
      j = 0;
    }
    String decryptedStr = new String.fromCharCodes(rawDecrypted);
    // Update Decrypte Reply Board
    _state.decryptreply = decryptedStr;
    // reset
    listStrTOListInt.clear();
    _state.render(() {});
  }

  void addReply() async {
    await Navigator.pushNamed(
      _state.context,
      AddReplyScreen.routeName,
      arguments: {
        'user': _state.user,
        'thread': _state.thread,
        'message': _state.decryptmsg,
        'replies': _state.replies,
      },
    );
    _state.render(() {});
  }

  void onSavedPassCode(String value) {
    passkey = value;
  }

  void onLongPress(int index) {
    _state.render(() {
      delIndex = (delIndex == index ? null : index);
    });
  }

  void delete() async {
    try {
      ReplyBoard reply = _state.replies[delIndex];
      await FirebaseController.deleteReply(reply);
      _state.render(() {
        _state.replies.removeAt(delIndex);
      });
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Delete Message error',
        content: e.message ?? e.toString(),
      );
    }
  }
}
