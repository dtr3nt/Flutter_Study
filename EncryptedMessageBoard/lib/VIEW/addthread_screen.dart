import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hush/CONTROLLER/firebase_controller.dart';
import 'package:hush/MODEL/thread_board.dart';
import 'package:hush/VIEW/mydialog.dart';

class AddThreadScreen extends StatefulWidget {
  static const routeName = '/threadBoardScreen/addThreadScreen';
  @override
  State<StatefulWidget> createState() {
    return _AddThreadState();
  }
}

class _AddThreadState extends State<AddThreadScreen> {
  _Controller con;
  var formKey = GlobalKey<FormState>();
  User user;
  List<ThreadBoard> threads;

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
    threads ??= args['threads'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Thread'),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Thread Title',
                ),
                autocorrect: true,
                validator: con.validatorTitle,
                onSaved: con.onSavedTitle,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Thread Main Message',
                ),
                maxLines: 6,
                autocorrect: true,
                validator: con.validatorMessage,
                onSaved: con.onSavedMessage,
              ),
              RaisedButton(
                child: Text('Publish Thread'),
                onPressed: con.publishThread,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _AddThreadState _state;
  _Controller(this._state);
  String title;
  String message;

  void publishThread() async {
    if (!_state.formKey.currentState.validate()) {
      return;
    }

    _state.formKey.currentState.save();

    try {
      MyDialog.circularProgressStart(_state.context);

      var thread = ThreadBoard(
        threadTitle: title,
        threadBy: _state.user.email,
        threadMessage: message,
      );
      thread.docId = await FirebaseController.publishThread(thread);
      _state.threads.insert(0, thread);

      MyDialog.circularProgressEnd(_state.context);
    } catch (e) {
      MyDialog.circularProgressEnd(_state.context);
      MyDialog.info(
        context: _state.context,
        title: 'FireBase Thread Upload Error',
        content: e.message ?? e.toString(),
      );
    }

    Navigator.pop(_state.context);
  }

  String validatorTitle(String value) {
    if (value == null || value.trim().length < 1) {
      return 'Atleast 1 char needed';
    } else {
      return null;
    }
  }

  void onSavedTitle(String value) {
    this.title = value;
  }

  String validatorMessage(String value) {
    if (value == null || value.trim().length < 1) {
      return 'Atleast 1 char needed';
    } else {
      return null;
    }
  }

  void onSavedMessage(String value) {
    this.message = value;
  }
}
