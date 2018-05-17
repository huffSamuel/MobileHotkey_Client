import 'package:flutter/material.dart';
import 'package:mobile_hotkey/data/macro.dart';
import 'package:mobile_hotkey/util/server_discoverer.dart';
import 'package:mobile_hotkey/data/macro_data_impl.dart';
import 'package:mobile_hotkey/ui/macro/macro_tile.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  void handleMacroTap(int id) {
    debugPrint(id.toString());
    final url = Uri.encodeFull(("http://$_serverAddress:12125/api/macros"));
    final body = new JsonCodec().encode(id);

    http.post(url,
      headers: { "Content-type": "application/json", "Accept": "application/json"},
      body: body
      );
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
      widget = Container(
        padding: const EdgeInsets.only(left:16.0, right:16.0, top:24.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left:16.0, right:16.0),
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Looking for server...",
                  style: TextStyle(
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
      widget = Container(
        padding: const EdgeInsets.only(left:16.0, right:16.0, top:24.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Loading macros...",
                  style: TextStyle(
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
        child = Wrap(
          spacing: 6.0,
          runSpacing: 4.0,
          children: _macros.map((macro) { 
            return GestureDetector(
              onTap: () => handleMacroTap(macro.id),
               child: MacroTile(macro) 
            );
            }).toList()
        );
      }
      else {
        child = Container(
        padding: const EdgeInsets.only(left:16.0, right:16.0, top:24.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "No macros found...",
                  style: TextStyle(
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

      widget = Expanded(
        child: RefreshIndicator(
          onRefresh: handleRefresh,
          child: child
        )
      );
    }

    return widget;
  }
}