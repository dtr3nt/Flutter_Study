import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hush/VIEW/addmessage_screen.dart';
import 'package:hush/VIEW/addreply_screen.dart';
import 'package:hush/VIEW/addthread_screen.dart';
import 'package:hush/VIEW/mythread_screen.dart';
import 'package:hush/VIEW/thread_screen.dart';
import 'package:hush/VIEW/messageboard_screen.dart';
import 'package:hush/VIEW/reply_screen.dart';
import 'package:hush/VIEW/signin_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(HushApp());
}

class HushApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: SignInScreen.routeName,
      routes: {
        SignInScreen.routeName: (context) => SignInScreen(),
        ThreadBoardScreen.routeName: (context) => ThreadBoardScreen(),
        AddThreadScreen.routeName: (context) => AddThreadScreen(),
        MessageBoardScreen.routeName: (context) => MessageBoardScreen(),
        AddMessageScreen.routeName: (context) => AddMessageScreen(),
        ReplyBoardScreen.routeName: (context) => ReplyBoardScreen(),
        AddReplyScreen.routeName: (context) => AddReplyScreen(),
        MyThreadScreen.routeName: (context) => MyThreadScreen(),
      },
    );
  }
}
