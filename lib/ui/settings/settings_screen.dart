import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        spacing: 10,
        children: [
          SizedBox(height: 5),
          DarkModeCard(),
          Divider(
            height: 2,
            indent: 24,
            endIndent: 24,
            thickness: 0.5,
          ),
          LanguadeCard(),
          Divider(
            height: 2,
            indent: 24,
            endIndent: 24,
            thickness: 0.5,
          ),
        ],
      ),
    );
  }
}

class DarkModeCard extends StatefulWidget {
  const DarkModeCard({super.key});

  @override
  State<DarkModeCard> createState() => _DarkModeCardState();
}

class _DarkModeCardState extends State<DarkModeCard> {
  bool _isDarkMode = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          Image.asset(
            'assets/nightmode.png',
            height: 40,
            width: 40,
          ),
          SizedBox(width: 15),
          Text(
            'Dark mode',
            style: TextStyle(fontSize: 18),
          ),
          Spacer(),
          Switch(
            value: _isDarkMode,
            onChanged: (val) => setState(() {
              _isDarkMode = !_isDarkMode;
            }),
            activeThumbColor: Colors.grey.shade500,
          )
        ],
      ),
    );
  }
}

class LanguadeCard extends StatefulWidget {
  const LanguadeCard({super.key});

  @override
  State<LanguadeCard> createState() => _LanguadeCardState();
}

class _LanguadeCardState extends State<LanguadeCard> {
  final List<bool> _selectedLang = <bool>[true, false];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          Image.asset(
            'assets/book.png',
            height: 40,
            width: 40,
          ),
          SizedBox(width: 15),
          Text(
            'Language',
            style: TextStyle(fontSize: 18),
          ),
          Spacer(),
          SizedBox(
            height: 40,
            child: ToggleButtons(
              direction: Axis.horizontal,
              onPressed: (int index) {
                setState(() {
                  for (int i = 0; i < _selectedLang.length; i++) {
                    _selectedLang[i] = i == index;
                  }
                });
              },
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              selectedBorderColor: Colors.black12,
              selectedColor: Colors.white,
              fillColor: Colors.grey.shade500,
              color: Colors.black,
              isSelected: _selectedLang,
              children: langs,
            ),
          ),
        ],
      ),
    );
    ;
  }
}

const List<Widget> langs = <Widget>[Text('ru'), Text('eng')];
