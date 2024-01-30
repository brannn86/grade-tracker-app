import 'package:flutter/material.dart';
import 'package:grade_app/pages/add.dart';
import 'package:grade_app/pages/graph.dart';
import 'package:grade_app/pages/home.dart';
import 'package:grade_app/pages/list.dart';
import 'package:grade_app/pages/settings.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int selectedPage = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  void _navigateBottomBar(int index) {
    setState(() {
      selectedPage = index;
      _tabController.animateTo(index,
          duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
    });
  }

  final List<Widget> _pages = [
    const HomePage(),
    const GraphPage(),
    const AddPage(),
    const ListPage(),
    const SettingsPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: _pages),
      // Home
      bottomNavigationBar: GNav(
        onTabChange: (selectedPage) => _navigateBottomBar(selectedPage),
        backgroundColor: Colors.white,
        iconSize: 24,
        gap: 8,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        tabMargin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        tabBackgroundColor: Colors.white,
        tabActiveBorder: Border.all(color: Colors.black),
        tabs: const [
          GButton(
            icon: Icons.home_outlined,
            text: 'Home',
          ),

          // Graph
          GButton(
            icon: Icons.auto_graph,
            text: 'Graph',
          ),

          // Add
          GButton(
            icon: Icons.add_circle_outline,
            text: 'Add',
          ),

          // List
          GButton(
            icon: Icons.list,
            text: 'List',
          ),

          // More
          GButton(
            icon: Icons.more_horiz,
            text: 'More',
          )
        ],
      ),
    );
  }
}
