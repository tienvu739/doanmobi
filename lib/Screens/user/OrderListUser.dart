import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderUser extends StatefulWidget {
  const OrderUser({super.key});

  @override
  State<OrderUser> createState() => _OrderUserState();
}

class _OrderUserState extends State<OrderUser> {
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    final id = prefs.getString('auth_id') ?? '';

    final url = Uri.parse(
        'https://10.0.2.2:7226/api/Order/getOrdersByUserId?idUser=$id');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        setState(() {
          orders = responseData.map<Map<String, dynamic>>((order) {
            return {
              'dateCreated': order['dateCreated'],
              'checkInDate': order['checkInDate'],
              'checkOutDate': order['checkOutDate'],
              'price': order['price'],
              'hotelName': order['hotelName'],
              'roomName': order['roomName']
            };
          }).toList();
        });
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách đơn đặt hàng'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: orders.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return Card(
              child: ListTile(
                title: Text(
                  'Khách sạn: ${order['hotelName']}',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Phòng: ${order['roomName']}',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text('Ngày tạo: ${order['dateCreated']}',
                        style: TextStyle(fontSize: 15)),
                    Text('Ngày nhận phòng: ${order['checkInDate']}',
                        style: TextStyle(fontSize: 15)),
                    Text('Ngày trả phòng: ${order['checkOutDate']}',
                        style: TextStyle(fontSize: 15)),
                    Text(
                      'Giá: ${order['price']} VND',
                      style: TextStyle(color: Colors.red, fontSize: 15),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}