import 'package:doanmobi/Screens/user/CommentScreen.dart';
import 'package:doanmobi/models/hotel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CommentableHotelsPage2 extends StatefulWidget {
  @override
  _CommentableHotelsPageState2 createState() => _CommentableHotelsPageState2();
}

class _CommentableHotelsPageState2 extends State<CommentableHotelsPage2> {
  List<Hotel> _hotels = [];

  @override
  void initState() {
    super.initState();
    _fetchHotels();
  }

  Future<void> _fetchHotels() async {
    final prefs = await SharedPreferences.getInstance();
    final _idUser = prefs.getString('auth_id') ?? '';
    final _token = prefs.getString('auth_token') ?? '';
    final url = Uri.parse('https://10.0.2.2:7226/api/Evaluate/getUserHotelsWithComments?idUser=$_idUser');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
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
      body: ListView.builder(
        itemCount: _hotels.length,
        itemBuilder: (context, index) {
          final hotel = _hotels[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              contentPadding: EdgeInsets.all(16.0),
              title: Text(hotel.nameHotel),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(hotel.addressHotel),
                ],
              ),
              leading: hotel.images.isNotEmpty
                  ? Image.memory(
                base64Decode(hotel.images[0].imageData),
                fit: BoxFit.cover,
                width: 80,
                height: 80,
              )
                  : Image.network(
                'https://via.placeholder.com/80',
                fit: BoxFit.cover,
                width: 80,
                height: 80,
              ),
            ),
          );
        },
      ),
    );
  }
}
