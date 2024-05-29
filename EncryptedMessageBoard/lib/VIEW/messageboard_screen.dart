import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hush/CONTROLLER/firebase_controller.dart';
import 'package:hush/MODEL/message_board.dart';
import 'package:hush/MODEL/reply_board.dart';
import 'package:hush/MODEL/thread_board.dart';
import 'package:hush/VIEW/addmessage_screen.dart';
import 'package:hush/VIEW/mydialog.dart';
import 'package:hush/VIEW/reply_screen.dart';

class MessageBoardScreen extends StatefulWidget {
  static const routeName = '/threadBoardScreen/messageBoardScreen';
  @override
  State<StatefulWidget> createState() {
    return _MessageBoardState();
  }
}

class _MessageBoardState extends State<MessageBoardScreen> {
  //
  User user;
  ThreadBoard thread;
  List<MessageBoard> messages;
  var formKey = GlobalKey<FormState>();

  _Controller con;
  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    user ??= args['user'];
    thread ??= args['thread'];
    messages ??= args['messages'];

    return Scaffold(
      appBar: AppBar(
        title: Text('MSG'),
        titleSpacing: 2.0,
        actions: <Widget>[
          con.delIndex == null
              ? Row(
                  children: [
                    Container(
                      width: 300.0,
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
                          validator: con.validatorPassCode,
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
        onPressed: con.addMessage,
      ),
      body: ListView(
        children: <Widget>[
          Card(
            child: Text(
              thread.threadMessage,
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
          messages.length == 0
              ? Text('No messages')
              : ListView.builder(
                  itemCount: messages.length,
                  shrinkWrap: true,
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
                      title: Text(messages[index].message),
                      subtitle: Column(
                        children: <Widget>[
                          Text('Author: ${messages[index].author}'),
                          Text('Date: ${messages[index].datePublished}'),
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
  _MessageBoardState _state;
  _Controller(this._state);
  int delIndex;
  String passkey;
  List<String> messageTOListStr;
  List<int> listStrTOListInt = List<int>();

  void addMessage() async {
    await Navigator.pushNamed(
      _state.context,
      AddMessageScreen.routeName,
      arguments: {
        'user': _state.user,
        'thread': _state.thread,
        'messages': _state.messages,
      },
    );
    _state.render(() {});
  }

  void onTap(int index) async {
    // Vaildate Form
    if (!_state.formKey.currentState.validate()) {
      return;
    }
    _state.formKey.currentState.save();
    // Divide Message: String into List of Strings
    messageTOListStr = _state.messages[index].message.split(',').toList();
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
    // Send Decrypted Message to Chat Reply Forum
    List<ReplyBoard> replies = await FirebaseController.getReplies(
        _state.thread, _state.messages[index].docId);
    Navigator.pushNamed(
      _state.context,
      ReplyBoardScreen.routeName,
      arguments: {
        'user': _state.user,
        'thread': _state.thread,
        'message': decryptedStr,
        'msgDoc': _state.messages[index].docId,
        'replies': replies,
      },
    );
    listStrTOListInt.clear();
    _state.render(() {});
  }

  void onSavedPassCode(String value) {
    print('passcode before : $passkey');
    passkey = value;
    print('passcode after : $passkey');
  }

  String validatorPassCode(String value) {
    if (value.length < 1) {
      return 'min 1 chars';
    } else {
      return null;
    }
  }

  void onLongPress(int index) {
    _state.render(() {
      delIndex = (delIndex == index ? null : index);
    });
  }

  void delete() async {
    try {
      MessageBoard message = _state.messages[delIndex];
      await FirebaseController.deleteMessage(message);
      _state.render(() {
        _state.messages.removeAt(delIndex);
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
