import 'dart:math';

import 'package:brainrot_flutter/home/views/mainView.dart';
import 'package:brainrot_flutter/home/views/makeImageView.dart';
import 'package:brainrot_flutter/login/views/loginView.dart';
import 'package:brainrot_flutter/home/searchView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Homeview extends ConsumerStatefulWidget {
  const Homeview({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<Homeview> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Widget> _pages = [
    Mainview(),
    Searchview(),
    Makeimageview(),
    Loginview(),
    Loginview(),
  ];

  void _onItemTapped(int index) {
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Brainrot"),
        actions: const [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Icon(Icons.favorite_outline),
                SizedBox(
                  width: 20,
                ),
                Icon(Icons.menu),
              ],
            ),
          )
        ],
      ),
      body: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
      ),
      bottomNavigationBar: CustomBottomNavigator(
          currentIndex: _currentIndex, onTap: _onItemTapped),
    );
  }
}

class CustomBottomNavigator extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigator(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  State<CustomBottomNavigator> createState() => _CustomBottomNavigator();
}

class _CustomBottomNavigator extends State<CustomBottomNavigator> {
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      elevation: 0,
      backgroundColor: Colors.white,
      onDestinationSelected: widget.onTap,
      indicatorColor: Color.fromARGB(15, 57, 57, 58),
      selectedIndex: widget.currentIndex,
      destinations: [
        const NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: "Home"),
        NavigationDestination(
          selectedIcon: Icon(Icons.search),
          icon: Icon(Icons.search_outlined),
          label: "Search",
        ),
        NavigationDestination(
            icon: FloatingActionButton.large(
              onPressed: () {
                widget.onTap(2);
              },
              backgroundColor: Colors.grey,
              child: Icon(Icons.add),
            ),
            label: ''),
        const NavigationDestination(
            selectedIcon: Icon(Icons.messenger),
            icon: Badge(
              child: Icon(Icons.messenger_sharp),
              label: Text("2"),
            ),
            label: "Messages"),
        const NavigationDestination(
            selectedIcon: Icon(Icons.person_outline),
            icon: Icon(Icons.person),
            label: "profile"),
      ],
    );
  }
}
