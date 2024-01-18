import 'package:flutter/material.dart';
import 'package:grade_app/pages/add.dart';
import 'package:grade_app/pages/graph.dart';
import 'package:grade_app/pages/list.dart';
import 'package:grade_app/pages/settings.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedPage = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  final List _pages = [
    HomePage(),
    GraphPage(),
    AddPage(),
    ListPage(),
    SettingsPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text("Home"),
      ),
      body: _pages[_selectedPage],
      // Home
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        onTap: _navigateBottomBar,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),

          // Graph
          BottomNavigationBarItem(
            icon: Icon(
              Icons.auto_graph,
            ),
            label: 'Graph',
          ),

          // Add
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle_outline,
            ),
            label: 'Add',
          ),

          // List
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list,
            ),
            label: 'List',
          ),

          // More
          BottomNavigationBarItem(
            icon: Icon(
              Icons.more_horiz,
            ),
            label: 'Settings',
          )
        ],
        iconSize: 32,
        unselectedItemColor: Colors.grey[600],
        selectedItemColor: Colors.deepOrange,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
                child: Icon(
              Icons.star,
              size: 48,
            )),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Profile"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profilepage');
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settingspage');
              },
            ),
          ],
        ),
      ),
    );
  }
}
