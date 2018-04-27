library mobile_hotkey;

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:mobile_hotkey/view/home.dart';
import 'package:mobile_hotkey/types/configuration.dart';
import 'package:mobile_hotkey/page/settings_page.dart';

part 'util/authentication.dart';
part 'page/splash_page.dart';

class MobileHotkeyApp extends StatefulWidget{

  const MobileHotkeyApp( {
    this.onSendFeedback,

    Key key
  }) : super(key: key);

  final VoidCallback onSendFeedback;

  @override
  MobileHotkeyAppState createState() => new MobileHotkeyAppState();
}

class MobileHotkeyAppState extends State<MobileHotkeyApp>{

  Configuration _configuration = new Configuration(
    themeMode: ThemeMode.dark,
    port: 55554
  );

  void configurationUpdater(Configuration value) {
    setState(() {
      _configuration = value;
    });
  }

  ThemeData get theme {
    switch(_configuration.themeMode) {
      case ThemeMode.light:
        return new ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.teal,
          accentColor: Colors.deepPurple
        );
      case ThemeMode.dark:
        return new ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.deepPurple
        );
    }
    assert(_configuration.themeMode != null);
    return null;
  }

  @override
  void initState(){
    super.initState();
  }

  @override 
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return new MaterialApp(
      title: 'Mobile Hotkey',
      theme: new ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: Colors.teal,
        accentColor: Colors.deepPurpleAccent,
        secondaryHeaderColor: Colors.orangeAccent
      ),
      home: new MobileHotkeyHome(),
      routes: <String, WidgetBuilder> {
        '/home': (BuildContext context) => new MobileHotkeyHome(),
        '/settings': (BuildContext context) => new MobileHotkeySettings(_configuration, configurationUpdater),
      }
    );
  }
}