import 'package:doanmobi/Screens/SignUpHoteler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'SignUp.dart';

class select extends StatefulWidget {
  const select({super.key});

  static const routeName = 'select';

  @override
  State<select> createState() => _selectState();
}

class _selectState extends State<select> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Đăng ký",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Sign(),
                        ));
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/icons/user.png',
                        width: 80.0,
                        height: 80.0,
                      ),
                      const SizedBox(height: 8.0),
                      const Text(
                        "Người dùng",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignHoteler(),
                        ));
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/icons/hoteler.png',
                        width: 80.0,
                        height: 80.0,
                      ),
                      const SizedBox(height: 8.0),
                      const Text(
                        "Chủ khách sạn",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
