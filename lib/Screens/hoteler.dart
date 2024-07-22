import 'package:doanmobi/Screens/HotelScreenHoteler.dart';
import 'package:doanmobi/Screens/hotelier/HotelierManager.dart';
import 'package:doanmobi/Screens/hotelier/OrderList.dart';
import 'package:doanmobi/Screens/hotelier/RoomHotelerScreen.dart';
import 'package:doanmobi/Screens/hotelier/profilehotelier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class hotelerScreen extends StatefulWidget {
  const hotelerScreen({super.key});

  @override
  State<hotelerScreen> createState() => _hotelerScreenState();
}

class _hotelerScreenState extends State<hotelerScreen> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HotelManagementScreen(),
          RoomHotelerScreen(),
          OrderPage(),
          profileHotelier(),
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
                Icons.room,
                size: 16.0,
              ),
              title: const Text("Khách sạn")),
          SalomonBottomBarItem(
              icon: const Icon(
                Icons.hotel,
                size: 16.0,
              ),
              title: const Text("Phòng")),
          SalomonBottomBarItem(
              icon: const Icon(
                Icons.shopping_cart,
                size: 16.0,
              ),
              title: const Text("Đơn hàng")),
          SalomonBottomBarItem(
              icon: const Icon(
                Icons.person,
                size: 16.0,
              ),
              title: const Text("My"))
        ],
      ),
    );
  }
}
