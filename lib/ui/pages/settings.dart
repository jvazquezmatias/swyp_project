import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:project/flutter_cupertino_settings.dart';

class SettingsPage extends StatefulWidget {
  static String tag = 'settings-page';
  @override
  SettingsTab createState() => new SettingsTab();
}

class SettingsTab extends State<SettingsPage> {
  double _slider = 0.5;
  bool _switch = false;
  int _index = 0;
  List<String> locations = ['Español', 'Catalán', 'Inglés'];
  String _selectedLocation = 'Español';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CupertinoSettings(
        items: <Widget>[
          CSHeader('Tipo de mapa:'),
          CSSelection(
            ['Carretera', 'Satélites', 'Terreno'],
            (int value) {
              setState(() {
                _index = value;
              });
            },
            currentSelection: _index,
          ),
          CSHeader('Formato mapa:'),
          CSSelection(
            ['Kilómetros', 'Millas'],
            (int value) {
              setState(() {
                _index = value;
              });
            },
            currentSelection: _index,
          ),
          CSHeader('Idioma:'),
          CSSelection(
            ['Español', 'Catalán', 'Inglés'],
            (int value) {
              setState(() {
                _index = value;
              });
            },
            currentSelection: _index,
          ),
        ],
      ),
    );
  }
}
