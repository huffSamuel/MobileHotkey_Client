import 'package:flutter/material.dart';
import 'package:mobile_hotkey/data/macro.dart';
import 'dart:convert';

class MacroTile extends StatelessWidget {
  final Macro macro;

  String getMessageBody() { 
    return JSON.encode(macro.id);
  }
  
  @override
  Widget build(BuildContext context) {
    final baseTextStyle = const TextStyle(
      fontFamily: 'Roboto'
    );

    final headerTextStyle = baseTextStyle.copyWith(
      fontSize: 26.0
    );

    final tileContent = new Container();

    final tile = new Container(
      height: 100.0,
      margin: new EdgeInsets.only(left: 2.0),
      decoration: new BoxDecoration(
        color: new Color(0xFF333366),
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