import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hush/CONTROLLER/firebase_controller.dart';
import 'package:hush/MODEL/message_board.dart';
import 'package:hush/MODEL/thread_board.dart';
import 'package:hush/VIEW/addthread_screen.dart';
import 'package:hush/VIEW/messageboard_screen.dart';
import 'package:hush/VIEW/mydialog.dart';
import 'package:hush/VIEW/mythread_screen.dart';
import 'package:hush/VIEW/signin_screen.dart';

class ThreadBoardScreen extends StatefulWidget {
  static const routeName = '/signInScreen/threadBoardScreen';

  @override
  State<StatefulWidget> createState() {
    return _ThreadBoardState();
  }
}

class _ThreadBoardState extends State<ThreadBoardScreen> {
  // Member Variables
  User user;
  List<ThreadBoard> threads;

  // Dedicated VIEW-CONTROLLER attachment
  _Controller con;
  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  // ReDraws Screen
  void render(fn) => setState(fn);

  //
  @override
  Widget build(BuildContext context) {
    // Catch arguments from signin_screen.dart if User and List null
    Map arg = ModalRoute.of(context).settings.arguments;
    user ??= arg['user'];
    threads ??= arg['threads'];

    //VIEW w/ Disabled Android Back Button
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Hush'),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountEmail: Text(user.email ?? 'Email Null'),
                accountName: Text(user.displayName ?? 'N/A'),
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app_outlined),
                title: Text('Sign Out'),
                onTap: con.signOut,
              ),
              ListTile(
                leading: Icon(Icons.tab),
                title: Text('My Threads'),
                onTap: con.myThreads,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: con.addThread,
        ),
        body: threads.length == 0
            ? Text('No Threads')
            : ListView.builder(
                itemCount: threads.length,
                itemBuilder: (BuildContext context, int index) => Card(
                  margin: EdgeInsets.all(10.0),
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    onTap: () => con.onTap(index),
                    title: Text(threads[index].threadTitle),
                    subtitle: Column(
                      children: <Widget>[
                        Text('Author: ${threads[index].threadBy}'),
                        Text('Date: ${threads[index].dateCreated}'),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

// DEDICATED VIEW-CONTROLLER
class _Controller {
  _ThreadBoardState _state;
  _Controller(this._state);

  void onTap(int index) async {
    List<MessageBoard> messages =
        await FirebaseController.getMessages(_state.threads[index]);
    Navigator.pushNamed(
      _state.context,
      MessageBoardScreen.routeName,
      arguments: {
        'user': _state.user,
        'thread': _state.threads[index],
        'messages': messages,
      },
    );
  }

  void signOut() async {
    try {
      await FirebaseController.signOut();
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Sign Out Error',
        content: e.message ?? e.toString(),
      );
    }
    Navigator.pushReplacementNamed(_state.context, SignInScreen.routeName);
  }

  void myThreads() async {
    List<ThreadBoard> myThreads =
        await FirebaseController.getMyThreads(_state.user.email);

    await Navigator.pushNamed(
      _state.context,
      MyThreadScreen.routeName,
      arguments: {
        'user': _state.user,
        'myThreads': myThreads,
      },
    );
    _state.render(() {});
  }

  void addThread() async {
    await Navigator.pushNamed(
      _state.context,
      AddThreadScreen.routeName,
      arguments: {
        'user': _state.user,
        'threads': _state.threads,
      },
    );
    _state.render(() {});
  }
}
