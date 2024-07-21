import 'dart:convert';

import 'package:doanmobi/Screens/home.dart';
import 'package:doanmobi/Screens/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Sign extends StatefulWidget {
  const Sign({super.key});

  @override
  State<Sign> createState() => _SignState();
}

class _SignState extends State<Sign> {
  String _account = '';
  String _email = '';
  String _password = '';
  String _name = '';
  String _sdt = '';
  Future<void> _register() async {
    final url = Uri.parse('https://10.0.2.2:7226/api/User/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'account': _account,
        'password': _password,
        'nameUser': _name,
        'email': _email,
        'phoneNumber': _sdt
      }),
    );

    if (response.statusCode == 200) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const loginScreen(),
          ));
      print('Registration successful');
    } else {
      print('Registration failed');
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
              "Đăng ký",
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
                _account = value;
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
              height: 5.0,
            ),
            TextField(
              onChanged: (value) {
                _name = value;
              },
              decoration: const InputDecoration(
                hintText: "Họ và tên",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            TextField(
              onChanged: (value) {
                _email = value;
              },
              decoration: const InputDecoration(
                hintText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            TextField(
              onChanged: (value) {
                _sdt = value;
              },
              decoration: const InputDecoration(
                hintText: "Số điện thoại",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 24.0,
            ),
            GestureDetector(
              onTap: () {
                _register();
              },
              child: Container(
                height: 46,
                width: 160,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: const Center(
                  child: Text(
                    "Đăng ký",
                    style: TextStyle(fontSize: 16.0, color: Colors.yellow),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
