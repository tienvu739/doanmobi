import 'dart:convert';
import 'package:doanmobi/Screens/hotelier/addHotelerScreenHotel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/hotel.dart';

class HoteScreenHoteler extends StatefulWidget {
  const HoteScreenHoteler({super.key});

  @override
  State<HoteScreenHoteler> createState() => _HoteScreenHotelerState();
}

class _HoteScreenHotelerState extends State<HoteScreenHoteler> {
  final addHotelRoute =
  MaterialPageRoute(builder: (context) => const addHotelerScreenHotel());

  List<Hotel> _hotels = [];

  @override
  void initState() {
    super.initState();
    _fetchHotels();
  }

  Future<void> _fetchHotels() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    final id = prefs.getString('auth_id') ?? '';
    final url = Uri.parse('https://10.0.2.2:7226/api/Hotel/dsAllHotel?idhotelier=$id');

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
          _hotels = data.map((hotelJson) => Hotel.fromJson(hotelJson)).toList();
        });
      } else {
        print('Failed to load hotels');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _refreshHotels() async {
    await _fetchHotels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshHotels,
        child: Column(
          children: [
            SizedBox(height: 16.0),
            // Danh sách khách sạn
            _hotels.isEmpty
                ? Center(child: CircularProgressIndicator())
                : Expanded(
              child: ListView.builder(
                itemCount: _hotels.length,
                itemBuilder: (context, index) {
                  final hotel = _hotels[index];
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
                          hotel.images.isNotEmpty
                              ? Image.memory(
                            base64Decode(hotel.images[0].imageData),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 200,
                          )
                              : Image.network(
                            'https://via.placeholder.com/150',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 200,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  hotel.nameHotel,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                                Text(
                                  hotel.statusHotel ? 'Đã duyệt' : 'Chưa duyệt',
                                  style: TextStyle(
                                    color: hotel.statusHotel
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.bold,
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
          ],
        ),
      ),
    );
  }
}
