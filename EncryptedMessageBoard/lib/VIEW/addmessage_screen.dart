import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hush/CONTROLLER/firebase_controller.dart';
import 'package:hush/MODEL/message_board.dart';
import 'package:hush/MODEL/thread_board.dart';
import 'package:hush/VIEW/mydialog.dart';

class AddMessageScreen extends StatefulWidget {
  static const routeName =
      '/threadBoardScreen/addMessageBoardScreen/addMessageScreen';
  @override
  State<StatefulWidget> createState() {
    return _AddMessageState();
  }
}

class _AddMessageState extends State<AddMessageScreen> {
  _Controller con;
  var formKey = GlobalKey<FormState>();
  User user;
  ThreadBoard thread;
  List<MessageBoard> messages;

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
        title: Text('Add Message'),
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
                  hintText: 'Message',
                ),
                maxLines: 6,
                autocorrect: true,
                validator: con.validatorMessage,
                onSaved: con.onSavedMessage,
              ),
              RaisedButton(
                child: Text('Publish Message'),
                onPressed: con.publishMessage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _AddMessageState _state;
  _Controller(this._state);
  String post;
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

  void publishMessage() async {
    if (!_state.formKey.currentState.validate()) {
      return;
    }

    _state.formKey.currentState.save();

    try {
      MyDialog.circularProgressStart(_state.context);

      var something = MessageBoard(
        author: _state.user.email,
        message: encrypt(post, passCode),
        datePublished: DateTime.now(),
      );

      something.docId =
          await FirebaseController.publishMessage(_state.thread, something);

      _state.messages.insert(0, something);

      MyDialog.circularProgressEnd(_state.context);
    } catch (e) {
      MyDialog.circularProgressEnd(_state.context);
      MyDialog.info(
        context: _state.context,
        title: 'FireBase Messages Upload Error',
        content: e.message ?? e.toString(),
      );
    }

    Navigator.pop(_state.context);
  }

  String validatorMessage(String value) {
    if (value == null || value.trim().length < 1) {
      return 'Atleast 1 char needed';
    } else {
      return null;
    }
  }

  void onSavedMessage(String value) {
    this.post = value;
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
