  import 'package:flutter/material.dart';
  import 'package:font_awesome_flutter/font_awesome_flutter.dart';
  import 'package:flutter_app/components/app_bar.dart';
  import 'package:flutter_app/screens/map_screen.dart';
  class Navigation extends StatefulWidget {
    @override
    _NavigationState createState() => _NavigationState();

  }

  class _NavigationState extends State<Navigation> {
    int _selectedIndex = 0;
    static List<Widget> _widgetOptions = <Widget> [
        Map()
      ];
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: appBar(),
        body: IndexedStack(index: _selectedIndex, children: _widgetOptions,),
        bottomNavigationBar: BottomNavigationBar(items: const <BottomNavigationBarItem>[
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
          selectedItemColor: Colors.pink[800],
          unselectedFontSize: 0.0,
          selectedFontSize: 0.0,
          elevation: 0.0,
          iconSize: 30,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.grey[850],
        ),
      );
  }
  }