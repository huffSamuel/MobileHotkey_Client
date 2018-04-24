import 'package:flutter/material.dart';
import 'package:mobile_hotkey/data/macro.dart';
import 'package:mobile_hotkey/ui/home/MacroRow.dart';
import 'package:mobile_hotkey/util/server_discoverer.dart';
import 'package:mobile_hotkey/data/macro_data_impl.dart';
import 'dart:async';

// TODO: This will need a more MVP approach so I can refresh from an external context

class MacrosView extends StatefulWidget{
  const MacrosView();

  void refresh(){
    
  }

  @override MacrosViewState createState() => new MacrosViewState();
}

class MacrosViewState extends State<MacrosView> {
  MacrosViewState(){
    _discoverer.onDiscovered.listen((e) => onServerFound(e.address));
    _repository.onLoaded.listen((e) => handleLoaded(e.macros));
    _discoverer.discover();
  }


  final ServerDiscoverer _discoverer = new ServerDiscoverer();
  final MacroRepository _repository = new MacroRepository();
  bool _lookingForServer = true;
  bool _loadingMacros = false;
  String _serverAddress = "";

  List<Macro> _macros;

  bool canRefresh(){
    return _lookingForServer == false && _loadingMacros == false;
  }

  Future<Null> handleRefresh() {
    if(canRefresh())
    {
      return _repository.fetch(_serverAddress);
    }
    else
    {
      throw new Error();
    }
  }

  void onServerFound(String serverAddress)
  {
    debugPrint("server found at $serverAddress");
    setState((){
      _serverAddress = serverAddress;
      _lookingForServer = false;
      _loadingMacros = true;
      _repository.fetch(_serverAddress);
    });
  }

  void handleLoaded(List<Macro> macros) {
    debugPrint("macros loaded...");
    setState((){
      _loadingMacros = false;
      _macros = macros;
    });
  }

  @override build(BuildContext context){
    Widget widget;

    // if looking for server
    // else if loading macros
    // else

    if(_lookingForServer) {
      widget = new Container(
        padding: const EdgeInsets.only(left:16.0, right:16.0, top:24.0),
        child: new Center(
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(left:16.0, right:16.0),
                child: new CircularProgressIndicator(),
              ),
              new Padding(
                padding: const EdgeInsets.all(16.0),
                child: new Text(
                  "Looking for server...",
                  style: new TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400
                  )
                )
              )
            ]
          )
        )
      );
    }
    else if(_loadingMacros)
    {
      widget = new Container(
        padding: const EdgeInsets.only(left:16.0, right:16.0, top:24.0),
        child: new Center(
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(16.0),
                child: new Text(
                  "Loading macros...",
                  style: new TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400
                  )
                )
              )
            ]
          )
        )
      );
    }
    else {
      Widget child;

      if(_macros.length > 0)
      {
        child = new ListView.builder(
            itemBuilder: (context, index) => new MacroRow(_macros[index], _serverAddress, 12125),
            itemCount: _macros.length,
            itemExtent: 152.0
          );
      }
      else {
        child = new Container(
        padding: const EdgeInsets.only(left:16.0, right:16.0, top:24.0),
        child: new Center(
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(16.0),
                child: new Text(
                  "No macros found...",
                  style: new TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400
                  )
                )
              )
            ]
          )
        )
      );
      }

      widget = new Expanded(
        child: new RefreshIndicator(
          onRefresh: handleRefresh,
          child: child
        )
      );
    }

    return widget;
  }
}