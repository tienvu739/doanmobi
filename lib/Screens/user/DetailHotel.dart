import 'dart:convert';

import 'package:doanmobi/Screens/user/CommentScreenHotel.dart';
import 'package:doanmobi/Screens/user/allRoomList.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/hotel.dart';

class HotelDetailPage extends StatefulWidget {
  final Hotel hotel;

  HotelDetailPage({required this.hotel});

  @override
  _HotelDetailPageState createState() => _HotelDetailPageState();
}

class _HotelDetailPageState extends State<HotelDetailPage> {
  int? totalPoints;
  List<dynamic> _hotelServices = [];

  @override
  void initState() {
    super.initState();
    _fetchPoints();
    _fetchHotelServices();
  }

  Future<void> _fetchPoints() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    final url = Uri.parse('https://10.0.2.2:7226/api/Evaluate/totalPoints?idHotel=${widget.hotel.idHotel}');
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
        setState(() {
          totalPoints = data['totalPoints'];
        });
      } else {
        print('Failed to load points: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _fetchHotelServices() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    final url = Uri.parse('https://10.0.2.2:7226/api/Service/services/${widget.hotel.idHotel}');
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
        setState(() {
          _hotelServices = data;
        });
      } else {
        print('Failed to load services: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: widget.hotel.images.isNotEmpty
                ? Image.memory(
              base64Decode(widget.hotel.images[0].imageData),
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
            )
                : Image.network(
              'https://via.placeholder.com/150',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
            ),
          ),
          Positioned(
            top: 72.0,
            left: 24.0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  color: Colors.white,
                ),
                child: Icon(Icons.arrow_back),
              ),
            ),
          ),
          Positioned(
            top: 72.0,
            right: 24.0,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  color: Colors.white,
                ),
                child: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.3,
            maxChildSize: 0.8,
            minChildSize: 0.3,
            builder: (context, scrollController) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32.0),
                    topRight: Radius.circular(32.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 16.0),
                      child: Container(
                        height: 5,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  widget.hotel.nameHotel,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis, // Thêm dấu "..." nếu nội dung quá dài
                                  maxLines: 2, // Giới hạn số dòng
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 25, color: Colors.red,),
                              SizedBox(
                                width: 5.0,
                              ),
                              Flexible(
                                child: Text(
                                  widget.hotel.addressHotel,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                  maxLines: 2,
                                ),
                              ),
                              Spacer(),
                              if (totalPoints != null)
                                Row(
                                  children: [
                                    Icon(Icons.star, color: Colors.amber,),
                                    SizedBox(width: 5.0),
                                    GestureDetector(
                                      child:Text(
                                        '$totalPoints',
                                        style: TextStyle(fontSize: 20.0),
                                      ) ,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CommentCreenHotel(hotelId: widget.hotel.idHotel),
                                          ),
                                        );
                                      },
                                    )
                                  ],
                                ),
                            ],
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Text(
                            "Thông tin",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Text(widget.hotel.describeHotel),
                          SizedBox(
                            height: 16.0,
                          ),
                          Text(
                            "Chính sách",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Text(widget.hotel.policyHotel),
                          SizedBox(
                            height: 16.0,
                          ),
                          Text(
                            "Dịch vụ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Column(
                            children: _hotelServices.map<Widget>((service) {
                              return ListTile(
                                title: Text(service['nameService']),
                                leading: Icon(Icons.check, color: Colors.green),
                              );
                            }).toList(),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AllRoomList(idHotel: widget.hotel.idHotel),
                                ),
                              );
                            },
                            child: Text('Xem phòng'),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
