import 'package:flutter/material.dart';
import 'package:grade_app/pages/add.dart';
import 'package:grade_app/pages/graph.dart';
import 'package:grade_app/pages/home.dart';
import 'package:grade_app/pages/list.dart';
import 'package:grade_app/pages/settings.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedPage = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  final List _pages = [
    const HomePage(),
    const GraphPage(),
    const AddPage(),
    const ListPage(),
    const SettingsPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPage],
      // Home
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        onTap: _navigateBottomBar,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        items: const [
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
    );
  }
}
