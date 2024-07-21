import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CommentPage extends StatefulWidget {
  final String idHotel;

  CommentPage({required this.idHotel});

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _describeEvaluate = '';
  int _point = 0;

  Future<void> _submitComment() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final prefs = await SharedPreferences.getInstance();
      final idUser = prefs.getString('auth_id') ?? '';
      final token = prefs.getString('auth_token') ?? '';

      final comment = {
        'title': _title,
        'describeEvaluate': _describeEvaluate,
        'point': _point,
        'idHotel': widget.idHotel,
        'idUser': idUser,
      };

      final url = Uri.parse('https://10.0.2.2:7226/api/Evaluate/addEvaluate');
      final body = jsonEncode(comment);

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
          // Handle successful comment submission
          print('Comment submitted successfully');
          Navigator.of(context).pop();
        } else {
          // Handle error response
          print('Failed to submit comment: ${response.body}');
        }
      } catch (error) {
        // Handle request error
        print('Error: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bình luận'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Tiêu đề'),
                onSaved: (value) {
                  _title = value ?? '';
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tiêu đề';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Mô tả đánh giá'),
                maxLines: 5,
                onSaved: (value) {
                  _describeEvaluate = value ?? '';
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mô tả đánh giá';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Điểm'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _point = int.parse(value ?? '0');
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập điểm';
                  }
                  final int? point = int.tryParse(value);
                  if (point == null || point < 0 || point > 10) {
                    return 'Điểm phải từ 0 đến 10';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitComment,
                child: Text('Gửi bình luận'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
