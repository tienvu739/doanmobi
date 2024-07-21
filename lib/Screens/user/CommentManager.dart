import 'package:doanmobi/Screens/user/CommentableHotelsPage.dart';
import 'package:doanmobi/Screens/user/CommentableHotelsPage2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommentManager extends StatefulWidget {
  const CommentManager({super.key});

  @override
  State<CommentManager> createState() => _CommentManagerState();
}

class _CommentManagerState extends State<CommentManager> with SingleTickerProviderStateMixin{
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
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Chưa đánh giá'),
            Tab(text: 'Đã đánh giá'),
          ],
        ),
        automaticallyImplyLeading: true,
        title: Text('Đánh giá'),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          CommentableHotelsPage(),
          CommentableHotelsPage2(),
        ],
      ),
    );
  }
}
