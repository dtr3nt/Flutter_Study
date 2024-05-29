import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hush/CONTROLLER/firebase_controller.dart';
import 'package:hush/MODEL/message_board.dart';
import 'package:hush/MODEL/reply_board.dart';
import 'package:hush/MODEL/thread_board.dart';
import 'package:hush/VIEW/mydialog.dart';

class AddReplyScreen extends StatefulWidget {
  static const routeName =
      '/threadBoardScreen/messageBoardScreen/replyBoardScreen/addReplyScreen';
  @override
  State<StatefulWidget> createState() {
    return _AddReplyState();
  }
}

class _AddReplyState extends State<AddReplyScreen> {
  _Controller con;
  var formKey = GlobalKey<FormState>();
  User user;
  ThreadBoard thread;
  String message;
  String msgDoc;
  List<ReplyBoard> replies;

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
    message ??= args['message'];
    msgDoc ??= args['msgDoc'];
    replies ??= args['replies'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Reply'),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'PassCode',
                ),
                autocorrect: false,
                validator: con.validatorPassCode,
                onSaved: con.onSavedPassCode,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Reply',
                ),
                maxLines: 6,
                autocorrect: true,
                validator: con.validatorReply,
                onSaved: con.onSavedReply,
              ),
              RaisedButton(
                child: Text('Publish Reply'),
                onPressed: con.publishReply,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _AddReplyState _state;
  _Controller(this._state);
  String reply;
  String passCode;

  String encrypt(String value, String passCode) {
    List<int> rawPassCode = passCode.codeUnits;
    List<int> rawMessage = value.codeUnits;
    List<int> rawEncryption = List<int>();
    int i = 0;
    int j = 0;
    for (i = 0; i < rawMessage.length;) {
      for (j = 0; j < rawPassCode.length; j++) {
        rawEncryption.add(rawMessage[i] ^ rawPassCode[j]);
        i++;
        if (i >= rawMessage.length) break;
      }
      j = 0;
    }
    return rawEncryption.toString();
  }

  void publishReply() async {
    if (!_state.formKey.currentState.validate()) {
      return;
    }

    _state.formKey.currentState.save();

    try {
      MyDialog.circularProgressStart(_state.context);

      var something = ReplyBoard(
        author: _state.user.email,
        reply: encrypt(reply, passCode),
        datePublished: DateTime.now(),
      );

      something.docId = await FirebaseController.publishReply(
        _state.thread,
        _state.msgDoc,
        something,
      );

      _state.replies.insert(0, something);

      MyDialog.circularProgressEnd(_state.context);
    } catch (e) {
      MyDialog.circularProgressEnd(_state.context);
      MyDialog.info(
        context: _state.context,
        title: 'FireBase Reply Upload Error',
        content: e.message ?? e.toString(),
      );
    }

    Navigator.pop(_state.context);
  }

  String validatorReply(String value) {
    if (value == null || value.trim().length < 1) {
      return 'Atleast 1 char needed';
    } else {
      return null;
    }
  }

  void onSavedReply(String value) {
    this.reply = value;
  }

  String validatorPassCode(String passCode) {
    if (passCode == null || passCode.length < 1) {
      return 'min 1 chars and must be shorter than the Msg';
    } else {
      return null;
    }
  }

  void onSavedPassCode(String value) {
    this.passCode = value;
  }
}
