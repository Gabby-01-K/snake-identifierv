// lib/pages/main_app_shell.dart

import 'package:flutter/material.dart';
import 'classifier_page.dart';
import 'models_page.dart';
import 'profile_page.dart';

class MainAppShell extends StatefulWidget {
  const MainAppShell({super.key});

  @override
  State<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends State<MainAppShell> {
  // This integer will track which page is currently selected
  int _selectedIndex = 0;

  // This list holds the 3 pages we want to switch between
  static final List<Widget> _pages = <Widget>[
    const ClassifierPage(), // existing page is now the first tab (i.e. the homepage)
    const ModelsPage(),     // The new models page
    ProfilePage(),    // The new profile page
  ];

  // This function is called when a user taps a navigation bar item
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // The body is set to the currently selected page from our list
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),

      // Here is the bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.model_training),
            label: 'Models',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: _onItemTapped,
      ),
    );
  }
}