import 'package:doanmobi/Screens/login.dart';
import 'package:doanmobi/Screens/user/CommentManager.dart';
import 'package:doanmobi/Screens/user/CommentScreen.dart';
import 'package:doanmobi/Screens/user/CommentableHotelsPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _name = '';
  String _idUser = '';
  String _token = '';
  String _phone = '';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    _idUser = prefs.getString('auth_id') ?? '';
    _token = prefs.getString('auth_token') ?? '';

    final url = Uri.parse('https://10.0.2.2:7226/api/User/idUser?id=$_idUser');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _name = data['name'];
          _phone = data['phone'];
        });
      } else {
        // Handle error response
        print('Failed to load user profile: ${response.body}');
      }
    } catch (error) {
      // Handle request error
      print('Error: $error');
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => loginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // Center the title
        title: Text('Hồ sơ cá nhân'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
              ),
              SizedBox(height: 16.0),
              Text(
                _name,
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 16.0),
              Text(
                'SDT: ' + _phone,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommentManager(),
                    ),
                  );
                },
                child: Text('Bình luận'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
