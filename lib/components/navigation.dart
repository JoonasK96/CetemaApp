import 'package:flutter/material.dart';

import 'package:flutter_app/screens/weather_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'package:flutter_app/screens/map_screen.dart';

class Navigation extends StatefulWidget {
  Navigation({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    MapScreen(),
    WeatherScreen(),
  ];
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Exit'),
            content: new Text('Do you want to exit the App?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
            elevation: 24,
          ),
        )) ??
        false;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: Colors.blue[50],
          body: IndexedStack(
            index: _selectedIndex,
            children: _widgetOptions,
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.map),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.cloud),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.cog),
                label: '',
              ),
            ],
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: Colors.blue[500],
            unselectedFontSize: 0.0,
            selectedFontSize: 0.0,
            elevation: 0.0,
            iconSize: 30,
            unselectedItemColor: Colors.blue[200],
            backgroundColor: Colors.white,
          ),
        ));
  }
}
