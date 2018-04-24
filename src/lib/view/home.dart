import 'package:flutter/material.dart';
import 'package:mobile_hotkey/view/drawer.dart';
import 'package:mobile_hotkey/ui/macros_view.dart';

class MobileHotkeyHome extends StatefulWidget{
  @override
  MobileHotkeyHomeState createState() => new MobileHotkeyHomeState();
}

class MobileHotkeyHomeState extends State<MobileHotkeyHome> {
  static final GlobalKey<MobileHotkeyHomeState> _scaffoldKey = new GlobalKey<MobileHotkeyHomeState>();
  @override
  void initState() {
    super.initState();
    // controller
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MacrosView macrosView = new MacrosView();

    Widget home = new Scaffold(
      key: _scaffoldKey,
      drawer: new MobileHotkeyDrawer(),
      body: new Column(
        children: <Widget>[
          new AppBar(
            backgroundColor: Colors.green,
            centerTitle: true,
            title: new Text("Mobile Hotkey"),
             actions: <Widget>[
               new GestureDetector(
                 onTap: null,
                 
                 child: new IconButton(
                   icon: new Icon(Icons.refresh),
                   tooltip: 'Refresh',
                   onPressed: () { macrosView.refresh(); })
               )
             ],
            ),
          macrosView
        ],
      )
    );

    return home;
  }
}
