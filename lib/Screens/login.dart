import 'dart:convert';

import 'package:doanmobi/Screens/SignUp.dart';
import 'package:doanmobi/Screens/home.dart';
import 'package:doanmobi/Screens/select.dart';
import 'package:doanmobi/models/hotel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'hoteler.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  static const routeName = 'login';

  @override
  State<loginScreen> createState() => _loginScreenState();
}
class _loginScreenState extends State<loginScreen> {
  String _email = '';
  String _password = '';
  Future<void> _login() async {
    final url = Uri.parse('https://10.0.2.2:7226/api/User/login?Account=$_email&Password=$_password');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {

      final Map<String, dynamic> responseData = json.decode(response.body);
      final String message = responseData['message'];
      final String token = responseData['token'];
      final String id = responseData['id'];

      // Lưu token bằng shared_preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      await prefs.setString('auth_id', id);
      if (message == 'user') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const homeScreen(),
          ),
        );
      }
      if (message == 'hotelier') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const hotelerScreen(),
          ),
        );
      }
      print('Login successful ' + token + ' '+id);
    } else {
      print('Login failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Đăng nhập",
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            const SizedBox(
              height: 40,
            ),
            TextField(
              onChanged: (value) {
                _email = value;
              },
              decoration: const InputDecoration(
                hintText: "Tài khoản",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            TextField(
              onChanged: (value) {
                _password = value;
              },
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "Mật khẩu",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 24.0,
            ),
            GestureDetector(
              onTap: () {
                _login();
              },
              child: Container(
                height: 46,
                width: 160,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: const Center(
                  child: Text(
                    "Đăng nhập",
                    style: TextStyle(fontSize: 16.0, color: Colors.yellow),
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const select(),
                            ));
                      },
                      child: const Text('Tạo tài khoản'),
                    ),

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
