import 'dart:async';
import 'dart:convert';
import 'package:doanmobi/Screens/user/allHomestayList.dart';
import 'package:doanmobi/Screens/user/allHoteList.dart';
import 'package:doanmobi/WIdget/Appbar.dart';
import 'package:doanmobi/helper/assets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../WIdget/CategoryCard.dart';
import '../models/Discount.dart';

class hotelScreen extends StatefulWidget {
  const hotelScreen({super.key});

  @override
  State<hotelScreen> createState() => _hotelScreenState();
}

class _hotelScreenState extends State<hotelScreen> {
  int _currentAdIndex = 0;
  late PageController _pageController;
  late Timer _timer;

  final List<String> _ads = [
    'assets/images/QC1.jpg',
    'assets/images/QC2.jpg',
    'assets/images/QC3.jpg',
    'assets/images/QC4.jpg',
    'assets/images/QC5.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentAdIndex < _ads.length - 1) {
        _currentAdIndex++;
      } else {
        _currentAdIndex = 0;
      }

      _pageController.animateToPage(
        _currentAdIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  Widget _buildItemCategory(
      Widget icon, Color color, Function() onTap, String title) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: icon,
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text(title)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return appBar(
      title: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Chào mừng bạn đến với Hotel Finder!',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 60.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CategoryCard(
                title: "Hotel",
                iconPath: 'assets/icons/hotel2.png',
                backgroundColor: Colors.cyan,
                destinationPage: AllHotelList(),
              ),
              const SizedBox(
                width: 16.0,
              ),
              CategoryCard(
                title: "Homestay",
                iconPath: 'assets/icons/house.png',
                backgroundColor: Colors.pinkAccent,
                destinationPage: AllHomestaylList(),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              "Khuyến mãi",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(
            height: 180.0, // Adjust height to fit the content
            child: FutureBuilder<List<Discount>>(
              future: fetchDiscounts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No discounts available'));
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Discount discount = snapshot.data![index];
                      return Container(
                        width: 250.0, // Adjust the width as per your requirement
                        padding: EdgeInsets.all(16.0),
                        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.8),
                              spreadRadius: 1,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              discount.nameDiscount,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(discount.describeDiscount),
                            SizedBox(height: 8.0),
                            Text('Đơn tối thiểu: ${discount.discountAmount} VND'),
                            Text('Giảm giá: ${discount.discountNumber}%'),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 24.0),
          Container(
            height: 160.0,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _ads.length,
              itemBuilder: (context, index) {
                return Image.asset(
                  _ads[index],
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Future<List<Discount>> fetchDiscounts() async {
  final response = await http.get(Uri.parse('https://10.0.2.2:7226/api/Discount/dsAllDiscount'));
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((discount) => Discount.fromJson(discount)).toList();
  } else {
    throw Exception('Failed to load discounts');
  }
}
