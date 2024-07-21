import 'dart:convert';
import 'package:doanmobi/Screens/user/DetailHotel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../models/hotel.dart';

class AllHomestaylList extends StatefulWidget {
  const AllHomestaylList({super.key});

  @override
  State<AllHomestaylList> createState() => _AllHomestaylListState();
}

class _AllHomestaylListState extends State<AllHomestaylList> {
  List<Hotel> _hotels = [];

  @override
  void initState() {
    super.initState();
    _fetchHotels();
  }

  Future<void> _fetchHotels() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    final url = Uri.parse('https://10.0.2.2:7226/api/Hotel/dsHomestay');

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
          _hotels = data.map((hotelJson) => Hotel.fromJson(hotelJson)).toList();
        });
      } else {
        print('Failed to load hotels');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhà nghỉ'),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 16.0),
          Expanded(
            child: _hotels.isEmpty
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
              onRefresh: _fetchHotels,
              child: ListView.builder(
                itemCount: _hotels.length,
                itemBuilder: (context, index) {
                  final hotel = _hotels[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              HotelDetailPage(hotel: hotel),
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
                              height: 150.0,
                              width: double.infinity,
                              child: hotel.images.isNotEmpty
                                  ? Image.memory(
                                base64Decode(hotel.images[0].imageData),
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
                                    hotel.nameHotel,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  Text(
                                    'Địa chỉ: ${hotel.addressHotel}',
                                    style: TextStyle(fontSize: 16.0),
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