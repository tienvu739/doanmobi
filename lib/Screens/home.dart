import 'dart:convert';

import 'package:doanmobi/Screens/Hotel.dart';
import 'package:doanmobi/Screens/hotelier/OrderList.dart';
import 'package:doanmobi/Screens/user/HotelSearchPage.dart';
import 'package:doanmobi/Screens/user/OrderListUser.dart';
import 'package:doanmobi/Screens/user/profileScreen.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:http/http.dart' as http;

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  static const routeName = 'homescrean';

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const hotelScreen(),
          HotelSearchPage(),
          OrderUser(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: const Color(0xff6155CC),
        unselectedItemColor: Colors.grey,
        margin: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 16.0,
        ),
        items: [
          SalomonBottomBarItem(
              icon: const Icon(
                Icons.home,
                size: 16.0,
              ),
              title: const Text("Home")),
          SalomonBottomBarItem(
              icon: const Icon(
                Icons.search,
                size: 16.0,
              ),
              title: const Text("Finder")),
          SalomonBottomBarItem(
              icon: const Icon(
                Icons.shopping_cart,
                size: 16.0,
              ),
              title: const Text('Order')),
          SalomonBottomBarItem(
              icon: const Icon(
                Icons.person,
                size: 16.0,
              ),
              title: const Text("Profile"))
        ],
      ),
    );
  }
}
