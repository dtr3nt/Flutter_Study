import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:photomemo/screens/detailed_screen.dart';
import 'package:photomemo/screens/edit_screen.dart';
import 'package:photomemo/screens/sendmessage_screen.dart';
import 'package:photomemo/screens/settings_screen.dart';
import 'package:photomemo/screens/sharedwith_screen.dart';
import 'package:photomemo/screens/signin_screen.dart';
import 'package:photomemo/screens/home_screen.dart';
import 'package:photomemo/screens/add_screen.dart';
import 'package:photomemo/screens/signup_screen.dart';
import 'package:photomemo/screens/message_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(PhotoMemoApp());
}

class PhotoMemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: SignInScreen.routeName,
      routes: {
        SignInScreen.routeName: (context) => SignInScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        AddScreen.routeName: (context) => AddScreen(),
        DetailedScreen.routeName: (context) => DetailedScreen(),
        EditScreen.routeName: (context) => EditScreen(),
        SharedWithScreen.routeName: (context) => SharedWithScreen(),
        SignUpScreen.routeName: (context) => SignUpScreen(),
        SettingScreen.routeName: (context) => SettingScreen(),
        MessageScreen.routeName: (context) => MessageScreen(),
        SendMessageScreen.routeName: (context) => SendMessageScreen(),
      },
    );
  }
}
