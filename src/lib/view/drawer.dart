import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'dart:math' as math;

class MobileHotkeyDrawerHeader extends StatefulWidget {
  const MobileHotkeyDrawerHeader({
    Key key, 
    this.light,
    this.account,
  }) : super(key: key);

  final bool light;
  final GoogleSignInAccount account;

  @override
  _MobileHotkeyDrawerState createState() => new _MobileHotkeyDrawerState();
}

class _MobileHotkeyDrawerState extends State<MobileHotkeyDrawerHeader> {

  final GoogleSignIn googleSignIn = new GoogleSignIn();
  
  MaterialColor _logoColor = Colors.green;

  @override 
  Widget build(BuildContext context) {
    final double systemTopPadding = MediaQuery.of(context).padding.top;

    Widget drawerHeader;

    GoogleSignInAccount user = googleSignIn.currentUser;

    if(user == null) {
      drawerHeader = new DrawerHeader(
        decoration: new FlutterLogoDecoration(
          margin: new EdgeInsets.fromLTRB(12.0, 12.0 + systemTopPadding, 12.0, 12.0),
          style: FlutterLogoStyle.horizontal,
          lightColor: _logoColor.shade400,
          darkColor: _logoColor.shade900,
          textColor: const Color(0xFF9E9E9E)
        ),
        duration: const Duration(milliseconds: 750),
        child: new GestureDetector(
          onTap: () {
            final List<MaterialColor> logoColorOptions = <MaterialColor>[Colors.blue, Colors.amber, Colors.red, Colors.indigo, Colors.pink, Colors.purple];
            _logoColor = logoColorOptions[new math.Random().nextInt(logoColorOptions.length)];
          }
        )
      );
    } else {
      drawerHeader = new UserAccountsDrawerHeader(
        accountEmail: new Text(user.email),
        accountName: new Text(user.displayName),
        currentAccountPicture: new CircleAvatar(
          backgroundImage: new NetworkImage(user.photoUrl),
        )
      );
    }


    return new Semantics(
      label: 'Flutter',
      child: drawerHeader
    );
  }
}

class MobileHotkeyDrawer extends StatelessWidget {
  const MobileHotkeyDrawer({Key key, this.onSendFeedback }) : super(key: key);

  final VoidCallback onSendFeedback;

  @override 
  Widget build(BuildContext context) {
    final Widget sendFeedbackItem = new ListTile(
      leading: const Icon(Icons.report),
      title: const Text('Submit Issue'),
      onTap: onSendFeedback ?? () { launch('https://github.com/huffSamuel/MobileHotkey-Issues/issues/new'); }
    );

    final Widget aboutItem = new AboutListTile(
      icon: const FlutterLogo(),
      applicationVersion: 'MobileHotkey App v0.1'
    );

    final Widget settingsItem = new ListTile(
      leading: const Icon(Icons.settings),
      title: const Text('Settings'),
      onTap: () { Navigator.popAndPushNamed(context, '/settings'); }
    );

    final List<Widget> allDrawerItems = <Widget>[
      new MobileHotkeyDrawerHeader(),
    ]
    ..addAll(<Widget>[
      const Divider(),
      sendFeedbackItem,
      settingsItem,
      aboutItem
    ]);

    return new Drawer(child: new ListView(primary: false, children: allDrawerItems));
  }
}