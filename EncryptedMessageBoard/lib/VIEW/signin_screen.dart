import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hush/CONTROLLER/firebase_controller.dart';
import 'package:hush/MODEL/thread_board.dart';
import 'package:hush/VIEW/thread_screen.dart';
import 'package:hush/VIEW/mydialog.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = '/signInScreen';

  @override
  State<StatefulWidget> createState() {
    return _SignInState();
  }
}

class _SignInState extends State<SignInScreen> {
  _Controller con;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In Screen'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Image.asset('assets/images/hushIcon.jpg'),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Email',
                ),
                keyboardType: TextInputType.visiblePassword,
                autocorrect: false,
                validator: con.validatorEmail,
                onSaved: con.onSavedEmail,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Passcode',
                ),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                autocorrect: false,
                validator: con.validatorPasscode,
                onSaved: con.onSavedPasscode,
              ),
              RaisedButton(
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
                color: Colors.amber,
                onPressed: con.signIn,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _SignInState _state;
  _Controller(this._state);
  String email;
  String password;
  User user;

  String validatorEmail(String value) {
    if (value == null || !value.contains('@') || !value.contains('.')) {
      return 'Invalid Email Address';
    } else {
      return null;
    }
  }

  void onSavedEmail(String value) {
    email = value;
  }

  String validatorPasscode(String value) {
    if (value == null || value.length < 6) {
      return 'password min 6 chars';
    } else {
      return null;
    }
  }

  void onSavedPasscode(String value) {
    password = value;
  }

  signIn() async {
    // Validate and Save state
    if (!_state.formKey.currentState.validate()) {
      return;
    }
    _state.formKey.currentState.save();
    //Progress Wheel Starts
    MyDialog.circularProgressStart(_state.context);

    // Validate User's SignIn Cred
    try {
      user = await FirebaseController.signIn(email, password);
    } catch (e) {
      // If SignIn Error Progress Wheel Ends and Alert Dialog Shows
      MyDialog.circularProgressEnd(_state.context);
      MyDialog.info(
        context: _state.context,
        title: 'Sign In Error',
        content: e.message ?? e.toString(),
      );
      return;
    }

    // Sign In Succeeded
    try {
      // 1. read all Threads from Firebase MessageBoardThreads THEN Progess Wheel Ends
      List<ThreadBoard> threads = await FirebaseController.getThreads();
      MyDialog.circularProgressEnd(_state.context);

      // 2. navigate to Hush Screen to display MessageBoard Threads
      Navigator.pushReplacementNamed(
        _state.context,
        ThreadBoardScreen.routeName,
        arguments: {
          'user': user,
          'threads': threads,
        },
      );
    } catch (e) {
      // If SignIn Error Progress Wheel Ends and Alert Dialog Shows
      MyDialog.circularProgressEnd(_state.context);
      MyDialog.info(
        context: _state.context,
        title: 'Firebase/Firestore error',
        content: 'Cannot get Thread Board \n ${e.message}',
      );
    }
  }
}
