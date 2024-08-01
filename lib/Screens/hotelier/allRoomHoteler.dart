import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../models/room.dart';

class AllRoomHoteler extends StatefulWidget {
  const AllRoomHoteler({super.key});

  @override
  State<AllRoomHoteler> createState() => _AllRoomHotelerState();
}

class _AllRoomHotelerState extends State<AllRoomHoteler> {
  List<Room> _rooms = [];

  @override
  void initState() {
    super.initState();
    _fetchRooms();
  }

  Future<void> _fetchRooms() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('auth_id') ?? '';
    final token = prefs.getString('auth_token') ?? '';
    final url =
    Uri.parse('https://10.0.2.2:7226/api/Room/dsRoom?idhotelier=$id');
    try {
      final response = await http.post(
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

  Future<void> _toggleRoomStatus(String idRoom) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    final url =
    Uri.parse('https://10.0.2.2:7226/api/Room/toggleStatus?idRoom=$idRoom');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final updatedStatus = jsonDecode(response.body)['status'];
        setState(() {
          final roomIndex = _rooms.indexWhere((room) => room.idRoom == idRoom);
          if (roomIndex != -1) {
            _rooms[roomIndex] = _rooms[roomIndex].copyWith(statusRoom: updatedStatus);
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Trạng thái phòng đã được cập nhật.')),
        );
      } else {
        print('Failed to toggle room status: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xảy ra lỗi: $error')),
      );
    }
  }

  Future<String> _fetchHotelName(String idRoom) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    final url = Uri.parse('https://10.0.2.2:7226/api/Room/getHotelNameByRoomId?idRoom=$idRoom');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['hotelName'].toString();
      } else {
        print('Failed to fetch hotel name: ${response.body}');
        return 'Unknown Hotel';
      }
    } catch (error) {
      print('Error: $error');
      return 'Unknown Hotel';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  return Padding(
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
                            height: 200.0,
                            width: double.infinity,
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
                                FutureBuilder<String>(
                                  future: _fetchHotelName(room.idRoom),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Text('Đang tải...');
                                    } else if (snapshot.hasError) {
                                      return Text('Lỗi tải tên khách sạn');
                                    } else if (snapshot.hasData) {
                                      return Text(
                                        'Khách sạn: ${snapshot.data}',
                                        style: TextStyle(fontSize: 16.0),
                                      );
                                    } else {
                                      return Text('Khách sạn: Unknown Hotel');
                                    }
                                  },
                                ),
                                Text(
                                  'Giá: ${room.price} VND',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _toggleRoomStatus(room.idRoom);
                                    },
                                    child: Text(room.statusRoom
                                        ? 'Hết phòng'
                                        : 'Còn phòng',style: TextStyle(color: Colors.black),),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: room.statusRoom
                                          ? Colors.red
                                          : Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
