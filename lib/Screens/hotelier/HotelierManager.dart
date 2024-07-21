
import 'package:doanmobi/Screens/hotelier/addHotelerScreenHotel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../HotelScreenHoteler.dart';

class HotelManagementScreen extends StatefulWidget {
  const HotelManagementScreen({super.key});

  @override
  State<HotelManagementScreen> createState() => _HotelManagementScreenState();
}

class _HotelManagementScreenState extends State<HotelManagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý khách sạn'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Tất cả khách sạn'),
            Tab(text: 'Thêm khách sạn'),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Màn hình tất cả khách sạn
          HoteScreenHoteler(),
          // Màn hình thêm khách sạn
          addHotelerScreenHotel(),
        ],
      ),
    );
  }
}