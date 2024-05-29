import 'package:flutter/material.dart';
import 'package:photomemo/controller/firebasecontroller.dart';
import 'package:photomemo/screens/views/mydialog.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signInScreen/signUpScreen';
  @override
  State<StatefulWidget> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUpScreen> {
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
        title: Text('Create an Account'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Text(
                'Create an Account',
                style: TextStyle(fontSize: 25.0),
              ),
              TextFormField(
                decoration: InputDecoration(hintText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                validator: con.validatorEmail,
                onSaved: con.onSavedEmail,
              ),
              TextFormField(
                decoration: InputDecoration(hintText: 'Password'),
                autocorrect: false,
                obscureText: true,
                validator: con.validatorPassword,
                onSaved: con.onSavedPassword,
              ),
              RaisedButton(
                child: Text(
                  'Create',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
                color: Colors.blue,
                onPressed: con.signUp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _SignUpState _state;
  _Controller(this._state);
  String email;
  String password;

  String validatorEmail(String value) {
    if (value.contains('@') && value.contains('.'))
      return null;
    else
      return 'Invalied Email';
  }

  void onSavedEmail(String value) {
    this.email = value;
  }

  String validatorPassword(String value) {
    if (value.length < 6)
      return 'min 6 chars';
    else
      return null;
  }

  void onSavedPassword(String value) {
    this.password = value;
  }

  void signUp() async {
    if (!_state.formKey.currentState.validate()) return;
    _state.formKey.currentState.save();
    try {
      await FirebaseController.signUp(email, password);
      MyDialog.info(
        context: _state.context,
        title: 'Successsfully Created Account!',
        content: 'Go to Sign In',
      );
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'ERROR',
        content: e.message ?? e.toString(),
      );
    }
  }
}
