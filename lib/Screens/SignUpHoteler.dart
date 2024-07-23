import 'dart:convert';

import 'package:doanmobi/Screens/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'home.dart';

class SignHoteler extends StatefulWidget {
  const SignHoteler({super.key});

  @override
  State<SignHoteler> createState() => _SignHotelerState();
}

class _SignHotelerState extends State<SignHoteler> {
  final _formKey = GlobalKey<FormState>();
  String _account = '';
  String _email = '';
  String _password = '';
  String _name = '';
  String _sdt = '';
  String? _errorMessage;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final url = Uri.parse('https://10.0.2.2:7226/api/Hotelier/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nameHotelier': _name,
        'account': _account,
        'password': _password,
        'email': _email,
        'phoneNumber': _sdt
      }),
    );

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const loginScreen(),
        ),
      );
      print('Registration successful');
    } else {
      setState(() {
        _errorMessage = 'Registration failed: ${response.body}';
      });
      print('Registration failed: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
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
              TextFormField(
                onChanged: (value) {
                  _account = value;
                },
                decoration: const InputDecoration(
                  hintText: "Tài khoản",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tài khoản';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 5.0,
              ),
              TextFormField(
                onChanged: (value) {
                  _password = value;
                },
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Mật khẩu",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu';
                  } else if (value.length < 6) {
                    return 'Mật khẩu phải có ít nhất 6 ký tự';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 5.0,
              ),
              TextFormField(
                onChanged: (value) {
                  _name = value;
                },
                decoration: const InputDecoration(
                  hintText: "Họ và tên",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập họ và tên';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 5.0,
              ),
              TextFormField(
                onChanged: (value) {
                  _email = value;
                },
                decoration: const InputDecoration(
                  hintText: "Email",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập email';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Email không hợp lệ';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 5.0,
              ),
              TextFormField(
                onChanged: (value) {
                  _sdt = value;
                },
                decoration: const InputDecoration(
                  hintText: "Số điện thoại",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số điện thoại';
                  } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Số điện thoại không hợp lệ';
                  } else if (value.length < 10 || value.length > 11) {
                    return 'Số điện thoại phải có 10 hoặc 11 số';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 24.0,
              ),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
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
      ),
    );
  }
}
