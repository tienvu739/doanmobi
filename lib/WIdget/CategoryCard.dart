import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final Color backgroundColor;
  final Widget destinationPage; // Thêm destinationPage để chuyển trang

  CategoryCard({
    required this.title,
    required this.iconPath,
    required this.backgroundColor,
    required this.destinationPage, // Thêm destinationPage để chuyển trang
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationPage),
        );
      },
      child: Container(
        height: 123.0,
        width: 170.0,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 0.0,),
            Image.asset(
              iconPath,
              width: 60,
              height: 60,
            ),
          ],
        ),
      ),
    );
  }
}