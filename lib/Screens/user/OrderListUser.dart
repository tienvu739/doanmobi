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
              'id': order['id'],
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

  Future<void> _refreshOrders() async {
    await fetchOrders();
  }

  Future<void> _deleteOrder(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final url = Uri.parse('https://10.0.2.2:7226/api/Order/delete?id=$id');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          orders.removeWhere((order) => order['id'] == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đơn hàng đã được hủy thành công.')),
        );
      } else {
        throw Exception('Failed to delete order');
      }
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xảy ra lỗi: $error')),
      );
    }
  }

  Future<void> _showDeleteConfirmationDialog(String id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bạn có chắc chắn muốn hủy đơn hàng này không?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Không'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Có'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteOrder(id);
              },
            ),
          ],
        );
      },
    );
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
        child: RefreshIndicator(
          onRefresh: _refreshOrders,
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
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            _showDeleteConfirmationDialog(order['id']);
                          },
                          child: Text(
                            'Hủy',
                            style: TextStyle(color: Colors.red),
                          ),
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
    );
  }
}
