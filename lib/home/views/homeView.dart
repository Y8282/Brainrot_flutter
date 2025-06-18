import 'dart:math';

import 'package:brainrot_flutter/home/model/home_view_model.dart';
import 'package:brainrot_flutter/home/views/mainView.dart';
import 'package:brainrot_flutter/home/views/makeImageView.dart';
import 'package:brainrot_flutter/home/views/profileView.dart';
import 'package:brainrot_flutter/login/views/loginView.dart';
import 'package:brainrot_flutter/home/views/searchView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Homeview extends ConsumerStatefulWidget {
  const Homeview({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<Homeview> {
  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(homeViewModelProvider.notifier);
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
        controller: vm.pageController,
        children: vm.pages,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (value) {
          setState(() {
            vm.currentIndex = value;
          });
        },
      ),
      bottomNavigationBar: CustomBottomNavigator(
          currentIndex: vm.currentIndex, onTap: vm.onItemTapped),
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
        const NavigationDestination(
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
            selectedIcon: Icon(Icons.settings),
            icon: Badge(
              child: Icon(Icons.settings_outlined),
              label: Text("2"),
            ),
            label: "Setting"),
        const NavigationDestination(
            selectedIcon: Icon(Icons.person_outline),
            icon: Icon(Icons.person),
            label: "profile"),
      ],
    );
  }
}
