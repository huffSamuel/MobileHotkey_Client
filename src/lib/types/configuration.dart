import 'package:flutter/foundation.dart';

enum ThemeMode { light, dark }

class Configuration {
  Configuration({ @required this.port,
                  @required this.themeMode }) 
    : assert(port != null),
      assert(themeMode != null);

  final int port;
  final ThemeMode themeMode;

  Configuration copyWith({ int port, 
                           ThemeMode themeMode}) {
    return new Configuration( 
      port: port,
      themeMode: themeMode,
    );
  }

}