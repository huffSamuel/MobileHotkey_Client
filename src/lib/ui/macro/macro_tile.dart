import 'package:flutter/material.dart';
import 'package:mobile_hotkey/data/macro.dart';
import 'dart:convert';

class MacroTile extends StatelessWidget {
  final Macro macro;

  MacroTile(this.macro);

  String getMessageBody() { 
    return new JsonCodec().encode(macro.id);
  }
  
  @override
  Widget build(BuildContext context) {
    final tileContent = new Container(
      width: 145.0,
      height: 145.0,
      margin: new EdgeInsets.all(4.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(height: 4.0),
          new Center(
            child: new Text(macro.name,
            style: Theme.of(context).textTheme.title)
          )
        ],
      )
    );

    final tile = new Container(
      margin: new EdgeInsets.all(8.0),
      decoration: new BoxDecoration(
        color: Theme.of(context).accentColor,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(4.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: new Offset(0.0, 10.0)
          )
        ]
      ),
      child: tileContent
    );

    return tile;
  }
}