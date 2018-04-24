import 'package:flutter/material.dart';
import 'package:mobile_hotkey/types/configuration.dart';

class MobileHotkeySettings extends StatefulWidget {
  const MobileHotkeySettings(this.configuration, this.updater);

  final Configuration configuration;
  final ValueChanged<Configuration> updater;

  @override
  MobileHotkeySettingsState createState() => new MobileHotkeySettingsState();
}

class MobileHotkeySettingsState extends State<MobileHotkeySettings> {
  void _handleThemeChanged(ThemeMode value) {
    value ??= ThemeMode.light;
    sendUpdates(widget.configuration.copyWith(themeMode: value));
  }

  void sendUpdates(Configuration value)
  {
    if(widget.updater != null) {
      widget.updater(value);
    }
  }

  Widget _buildAppBar(BuildContext context) {
    return new AppBar(
      title: const Text('Settings')
    );
  }

  Widget _buildPane(BuildContext context) { 
    final List<Widget> rows = <Widget>[
      new ListTile(
        leading: const Icon(Icons.help),
        title: const Text('See help')
      )
      
    ];

    return new ListView(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      children: rows
    );
  }

  @override build(BuildContext context) {
    return new Scaffold(
      appBar: _buildAppBar(context),
      body: _buildPane(context)
    );
  }
}