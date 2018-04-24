import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile_hotkey/data/macro.dart';

class MacroRow extends StatelessWidget{

  final Uri address = new Uri(
    scheme: "http",
    host: "192.168.1.100",
    port: 12125,
    path: "/api/macros"
  );

  final Macro macro;
  final String host;
  final int port;

  MacroRow(this.macro, this.host, this.port);

  @override
  Widget build(BuildContext context){
    final macroThumbnail = new Container(
      margin: new EdgeInsets.symmetric(vertical: 16.0),
      alignment: FractionalOffset.centerLeft,
    );

    final baseTextStyle = const TextStyle(
      fontFamily: 'Roboto'
    );

    final regularTextStyle = baseTextStyle.copyWith(
      color: const Color(0xffb6b2df),
      fontSize: 9.0,
      fontWeight: FontWeight.w400
    );

    final headerTextStyle = regularTextStyle.copyWith(
      fontSize: 26.0
    );

    final macroCardContent = new Container(
      margin: new EdgeInsets.fromLTRB(76.0, 16.0, 16.0, 16.0),
      constraints: new BoxConstraints.expand(),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(height: 4.0),
          new Text(macro.name,
            style:headerTextStyle
          )
        ]
      )
    );

    final macroCard = new Container(
      height: 124.0,
      margin: new EdgeInsets.only(left:46.0),
      decoration: new BoxDecoration(
        color: new Color(0xFF333366),
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(4.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black12,
            blurRadius:10.0,
            offset: new Offset(0.0, 10.0)
          )
        ]
      ),
      child: macroCardContent
    );

    return new  GestureDetector(
      onTap: () => fireMacro(),
      child: new Container(
        margin: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 24.0
        ),
        child: new Stack(
          children: <Widget>[
            macroCard,
            macroThumbnail,
          ],
        )
      )
    );
  }

  void fireMacro() async {
    debugPrint("Firing macro $macro to $address");

    String url = Uri.encodeFull("http://$host:$port/api/macros");
    String body = JSON.encode(macro.id);

    debugPrint("Url: $url");
    debugPrint("Body: $body");

    await http.post(
      url,
      headers: { "Content-type": "application/json", "Accept": "application/json"},
      body: body
    );
  }
}