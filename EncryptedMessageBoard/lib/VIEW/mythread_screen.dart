import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hush/CONTROLLER/firebase_controller.dart';
import 'package:hush/MODEL/thread_board.dart';
import 'package:hush/VIEW/mydialog.dart';

class MyThreadScreen extends StatefulWidget {
  static const routeName = '/threadBoardScreen/myThreadScreen';
  @override
  State<StatefulWidget> createState() {
    return _MyThreadState();
  }
}

class _MyThreadState extends State<MyThreadScreen> {
  //
  User user;
  List<ThreadBoard> myThreads;
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
    //
    Map arg = ModalRoute.of(context).settings.arguments;
    user ??= arg['user'];
    myThreads ??= arg['myThreads'];
    //
    return Scaffold(
      appBar: AppBar(
        title: Text('My Threads'),
        actions: <Widget>[
          con.delIndex == null
              ? IconButton(
                  icon: Icon(Icons.delete_forever),
                  onPressed: () {},
                )
              : IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: con.delete,
                ),
        ],
      ),
      body: myThreads.length == 0
          ? Text('No Threads Created Yet')
          : ListView.builder(
              itemCount: myThreads.length,
              itemBuilder: (BuildContext context, int index) => Container(
                color: con.delIndex != null && con.delIndex == index
                    ? Colors.red[50]
                    : Colors.white,
                child: ListTile(
                  title: Text(myThreads[index].threadTitle),
                  subtitle: Column(
                    children: <Widget>[
                      Text('Author: ${myThreads[index].threadBy}'),
                      Text('Date: ${myThreads[index].dateCreated}'),
                    ],
                  ),
                  //onTap: () => con.onTap(index),
                  onLongPress: () => con.onLongPress(index),
                ),
              ),
            ),
    );
  }
}

class _Controller {
  _MyThreadState _state;
  _Controller(this._state);
  int delIndex;

  void delete() async {
    try {
      ThreadBoard myThreads = _state.myThreads[delIndex];
      await FirebaseController.deleteThread(myThreads);
      _state.render(() {
        _state.myThreads.removeAt(delIndex);
      });
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Delete My Thread error',
        content: e.message ?? e.toString(),
      );
    }
    _state.render(() {});
  }

  void onLongPress(int index) {
    _state.render(() {
      delIndex = (delIndex == index ? null : index);
    });
  }
}
