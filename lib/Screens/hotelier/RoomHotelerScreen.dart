import 'package:doanmobi/Screens/hotelier/addRoomScreen.dart';
import 'package:doanmobi/Screens/hotelier/allRoomHoteler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoomHotelerScreen extends StatefulWidget {
  const RoomHotelerScreen({super.key});

  @override
  State<RoomHotelerScreen> createState() => _RoomHotelerScreenState();
}

class _RoomHotelerScreenState extends State<RoomHotelerScreen> with SingleTickerProviderStateMixin{
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
        title: const Text('Quản lý phòng'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Tất cả phòng'),
            Tab(text: 'Thêm phòng'),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          AllRoomHoteler(),
          addRoomScreen(),
        ],
      ),
    );
  }
}
