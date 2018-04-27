import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'macro.dart';
import 'package:flutter/material.dart';

class MacrosLoadedEvent {
  List<Macro> macros;

  MacrosLoadedEvent(this.macros);
}

class MacroRepository
{
  var changeController = new StreamController<MacrosLoadedEvent>();  
  Stream<MacrosLoadedEvent> get onLoaded => changeController.stream;

  final HttpClient client = new HttpClient();
  final JsonDecoder decoder = new JsonDecoder();

  Future<Null> fetch(String serverAddress) async{
    debugPrint("getting data from http://$serverAddress/api/macros port 12125");
    final Uri address = new Uri(
    scheme: "http",
    host: serverAddress,
    port: 12125,
    path: "/api/macros"
  );

    var request = await client.getUrl(address);
    var response = await request.close();
    var responseBody = await response.transform(UTF8.decoder).join();
    final statusCode = response.statusCode;

    if(statusCode < 200 || statusCode >= 300 || responseBody == null){
      debugPrint("statuscode $statusCode");
      throw new FetchDataException("Error while getting macros");
    }

    List macroContainer = new JsonCodec().decode(responseBody);

    List<Macro> macros = new List<Macro>();

    macroContainer.forEach((element) {
      debugPrint("$element");
      macros.add(new Macro(id: element['Id'], name: element['Name']));
    });

    changeController.add(new MacrosLoadedEvent(macros));
    debugPrint("macroContainer = $macroContainer");

    return macros;
  }
}