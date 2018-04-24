import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';

class ServerDiscoveredEvent{
  String address;

  ServerDiscoveredEvent(this.address);
}

class ServerDiscoverer
{
  RawDatagramSocket socket;
  final int listeningPort = 55555;
  final int sendingPort = 55554;
  final InternetAddress address = InternetAddress.ANY_IP_V4;

  var changeController = new StreamController<ServerDiscoveredEvent>();
  Stream<ServerDiscoveredEvent> get onDiscovered => changeController.stream;

  ServerDiscoverer(){
  }

  void discover() async{
    socket = await RawDatagramSocket.bind(address, listeningPort);

    socket.writeEventsEnabled = true;
    socket.readEventsEnabled = true;
    String serverAddress = "";
  
    StreamSubscription socketListen;
    socketListen = socket.listen((RawSocketEvent event){
      if(event == RawSocketEvent.READ){
        Datagram packet = socket.receive();
        debugPrint('Received UDP packet: ${packet != null}');
        serverAddress = packet.address.address;
        debugPrint('From address $serverAddress');
        socketListen.cancel();
        socket.close();
        // TODO: Notify owning class that a server was discovered
        changeController.add(new ServerDiscoveredEvent(serverAddress));
      }
    });
  }
}