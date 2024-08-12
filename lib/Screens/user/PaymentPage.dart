import 'package:doanmobi/Screens/HotelScreenHoteler.dart';
import 'package:doanmobi/Screens/home.dart';
import 'package:doanmobi/Screens/user/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zalopay_sdk/flutter_zalopay_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/Discount.dart';

class PaymentPage extends StatefulWidget {
  final String roomId;
  final double pricePerNight;

  PaymentPage({required this.roomId, required this.pricePerNight});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  double _totalPrice = 0.0;

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _checkInDate && isCheckIn) {
      setState(() {
        _checkInDate = picked;
      });
    } else if (picked != null && picked != _checkOutDate && !isCheckIn) {
      setState(() {
        _checkOutDate = picked;
      });
    }

    if (_checkInDate != null && _checkOutDate != null) {
      _calculateTotalPrice();
    }
  }

  void _calculateTotalPrice() {
    if (_checkInDate != null && _checkOutDate != null) {
      final difference = _checkOutDate!.difference(_checkInDate!).inDays;
      setState(() {
        _totalPrice = widget.pricePerNight * difference;
        if (_selectedidDiscount != null) {
          final discount = idDiscount.firstWhere(
                (element) => element['idDiscount'] == _selectedidDiscount,
          );
          final discountAmount = discount['discountAmount'];
          setState(() {
            _totalPrice -= discountAmount;
          });
        }
      });
    }
  }

  Future<void> _submitOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final idUser = prefs.getString('auth_id') ?? '';
    final token = prefs.getString('auth_token') ?? '';

    final url = Uri.parse('https://10.0.2.2:7226/api/Order/addOrder');
    final body = jsonEncode({
      'dateCreated': DateTime.now().toIso8601String(),
      'checkInDate': _checkInDate!.toIso8601String(),
      'checkOutDate': _checkOutDate!.toIso8601String(),
      'price': _totalPrice,
      'idUser': idUser,
      'idDiscount': _selectedidDiscount,
      'idRoom': widget.roomId,
      'Stastus': true,
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        // Handle successful order submission
        print('Order submitted successfully');
      } else {
        // Handle error response
        print('Failed to submit order: ${response.body}');
      }
    } catch (error) {
      // Handle request error
      print('Error: $error');
    }
  }

  String? _selectedidDiscount;
  List<Map<String, dynamic>> idDiscount = [];

  @override
  void initState() {
    super.initState();
    fetchDiscounts();
  }

  Future<void> fetchDiscounts() async {
    final response = await http
        .get(Uri.parse('https://10.0.2.2:7226/api/Discount/dsAllDiscount'));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      setState(() {
        idDiscount = responseData.map<Map<String, dynamic>>((discount) {
          return {
            'idDiscount': discount['idDiscount'],
            'nameDiscount': discount['nameDiscount'],
            'describeDiscount': discount['describeDiscount'],
            'discountAmount': discount['discountAmount'],
            'discountNumber': discount['discountNumber']
          };
        }).toList();
      });
    } else {
      throw Exception('Failed to load discounts');
    }
  }

  String zpTransToken = "";
  String payResult = "";
  bool showResult = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thanh toán'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Chọn ngày nhận phòng:',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: () => _selectDate(context, true),
                      child: Text(
                        _checkInDate == null
                            ? 'Chọn ngày'
                            : _checkInDate!.toLocal().toString().split(' ')[0],
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Chọn ngày trả phòng:',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: () => _selectDate(context, false),
                      child: Text(
                        _checkOutDate == null
                            ? 'Chọn ngày'
                            : _checkOutDate!.toLocal().toString().split(' ')[0],
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Khuyến mãi:',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        hintText: 'Chọn khuyến mãi',
                      ),
                      value: _selectedidDiscount,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedidDiscount = newValue;
                          _calculateTotalPrice();
                        });
                      },
                      items: idDiscount.map<DropdownMenuItem<String>>(
                              (Map<String, dynamic> discount) {
                            return DropdownMenuItem<String>(
                              value: discount['idDiscount'],
                              child: Text(discount['nameDiscount']),
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thành tiền:',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$_totalPrice VND',
                      style: TextStyle(fontSize: 25, color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  int amount = _totalPrice.toInt();
                  var result = await createOrder(amount);
                  if (result != null) {
                    zpTransToken = result.zptranstoken;
                    print("zpTransToken $zpTransToken'.");
                    setState(() {
                      zpTransToken = result.zptranstoken;
                    });
                  }
                  FlutterZaloPaySdk.payOrder(zpToken: zpTransToken)
                      .then((event) {
                    setState(() {
                      switch (event) {
                        case FlutterZaloPayStatus.cancelled:
                          payResult = "User Huỷ Thanh Toán";
                          break;
                        case FlutterZaloPayStatus.success:
                          payResult = "Thanh toán thành công";
                          _submitOrder();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => homeScreen(),
                            ),
                          );
                          break;
                        case FlutterZaloPayStatus.failed:
                          payResult = "Thanh toán thất bại";
                          break;
                        default:
                          payResult = "Thanh toán thất bại";
                          break;
                      }
                    });
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 20),
                ),
                child: Text('Thanh toán'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
