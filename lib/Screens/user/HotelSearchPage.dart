import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doanmobi/models/hotel.dart';
import 'DetailHotel.dart';

class HotelSearchPage extends StatefulWidget {
  @override
  _HotelSearchPageState createState() => _HotelSearchPageState();
}

class _HotelSearchPageState extends State<HotelSearchPage> {
  List<Hotel> _hotels = [];
  String _searchQuery = '';
  String? _selectedRoomType;
  RangeValues _priceRange = RangeValues(0, 2000000); // Updated max value
  String _token = '';

  final List<String> _hotelTypes = [
    'Phòng Standard',
    'Phòng Superior',
    'Phòng Deluxe',
    'Phòng Suite'
  ];

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token') ?? '';
  }

  Future<void> _searchHotels() async {
    final url = Uri.parse('https://10.0.2.2:7226/api/Hotel/searchHotels'
        '?searchTerm=$_searchQuery'
        '&minPrice=${_priceRange.start}'
        '&maxPrice=${_priceRange.end}'
        '&roomType=${_selectedRoomType ?? ''}');
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
      } else if (response.statusCode == 404) {
        setState(() {
          _hotels = [];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không tìm thấy khách sạn nào phù hợp.')),
        );
      } else {
        final errorResponse = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorResponse['message'] ?? 'Failed to load hotels')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xảy ra lỗi: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tìm kiếm khách sạn'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 2.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Tên hoặc địa chỉ khách sạn'),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Loại phòng'),
                      value: _selectedRoomType,
                      items: _hotelTypes.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedRoomType = value;
                        });
                      },
                    ),
                    RangeSlider(
                      values: _priceRange,
                      min: 0,
                      max: 2000000, // Updated max value
                      divisions: 100,
                      labels: RangeLabels(
                        '${_priceRange.start.round()} VND',
                        '${_priceRange.end.round()} VND',
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _priceRange = values;
                        });
                      },
                    ),
                    Text('Giá: ${_priceRange.start.round()} VND - ${_priceRange.end.round()} VND'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _searchHotels,
              child: Text('Tìm kiếm'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _hotels.length,
                itemBuilder: (context, index) {
                  final hotel = _hotels[index];
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HotelDetailPage(hotel: hotel),
                          ),
                        );
                      },
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
            ),
          ],
        ),
      ),
    );
  }
}
