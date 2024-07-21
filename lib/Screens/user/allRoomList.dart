import 'dart:convert';

import 'package:doanmobi/Screens/user/DetailRoom.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../models/room.dart';

class AllRoomList extends StatefulWidget {
  const AllRoomList({super.key, required this.idHotel});

  final String idHotel;

  @override
  State<AllRoomList> createState() => _AllRoomListState();
}

class _AllRoomListState extends State<AllRoomList> {
  List<Room> _rooms = [];

  @override
  void initState() {
    super.initState();
    _fetchRooms();
  }

  Future<void> _fetchRooms() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    final url = Uri.parse(
        'https://10.0.2.2:7226/api/Room/idHotel?idHotel=${widget.idHotel}');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        setState(() {
          _rooms = data.map((roomJson) => Room.fromJson(roomJson)).toList();
        });
      } else {
        print('Failed to load rooms: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách phòng'),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 16.0),
          Expanded(
            child: _rooms.isEmpty
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
              onRefresh: _fetchRooms,
              child: ListView.builder(
                itemCount: _rooms.length,
                itemBuilder: (context, index) {
                  final room = _rooms[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailRoom(room: room),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 150.0, // Chiều cao mặc định
                              width: double.infinity, // Chiều rộng mặc định (full width)
                              child: room.imageRooms.isNotEmpty
                                  ? Image.memory(
                                base64Decode(room.imageRooms[0].imageData),
                                fit: BoxFit.cover,
                              )
                                  : Image.network(
                                'https://via.placeholder.com/150',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    room.nameRoom,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  Text(
                                    room.statusRoom ? 'Còn phòng' : 'Hết phòng',
                                    style: TextStyle(
                                      color: room.statusRoom ? Colors.green : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Loại phòng: ${room.typeRoom}',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  Text(
                                    'Giá: ${room.price} VND',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}