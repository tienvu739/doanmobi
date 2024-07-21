import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../WIdget/CategoryCard.dart';

class mainhotel extends StatefulWidget {
  const mainhotel({super.key});



  @override
  State<mainhotel> createState() => _mainhotelState();
}

class _mainhotelState extends State<mainhotel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              child: const Text(
                  "Chào mừng bạn đến với hotel finder!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CategoryCard(
                  title: "Hotel",
                  iconPath: 'assets/icons/hotel2.png',
                  backgroundColor: Colors.cyan,
                  destinationPage: Container(),
                ),
                CategoryCard(
                  title: "Homestay",
                  iconPath: 'assets/icons/house.png',
                  backgroundColor: Colors.pinkAccent,
                  destinationPage: Container(),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
