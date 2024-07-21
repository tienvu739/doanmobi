import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../hoteler.dart';

class addRoomScreen extends StatefulWidget {
  const addRoomScreen({super.key});

  @override
  State<addRoomScreen> createState() => _addRoomScreenState();
}

class _addRoomScreenState extends State<addRoomScreen> {
  Uint8List? _image;
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _policyController = TextEditingController();
  final _priceController = TextEditingController();
  final _bedController = TextEditingController();
  final _peopleController = TextEditingController();

  final List<String> _hotelTypes = [
    'Phòng Standard',
    'Phòng Superior',
    'Phòng Deluxe',
    'Phòng Suite'
  ];
  String? _selectedRoomType;
  String? _selectedidHotel;
  List<Map<String, String>> _idhotel = [];
  final allHotelsRoute = MaterialPageRoute(builder: (context) => const hotelerScreen());


  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _image = bytes;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getName();
  }

  Future<void> _getName() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('auth_id') ?? '';
    final token = prefs.getString('auth_token') ?? '';
    final url = Uri.parse('https://10.0.2.2:7226/api/Hotel/nameHotel?id=$id');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      setState(() {
        _idhotel = responseData.map<Map<String, String>>((hotel) {
          return {
            'idHotel': hotel['idHotel'],
            'nameHotel': hotel['nameHotel'],
          };
        }).toList();
      });
    } else {
      print('failed');
    }
  }

  Future<void> _submitForm() async {
    final url = Uri.parse('https://10.0.2.2:7226/api/Room/addRoom');

    // Lấy token và id từ SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    // Chuẩn bị thân yêu cầu
    final requestBody = {
      "nameRoom": _nameController.text,
      "areaRoom": int.tryParse(_addressController.text) ?? 0,
      "people": int.tryParse(_peopleController.text) ?? 0,
      "policyRoom": _policyController.text,
      "bedNumber": int.tryParse(_bedController.text) ?? 0,
      "statusRoom": true,
      "typeRoom": _selectedRoomType ?? '',
      "price": int.tryParse(_priceController.text) ?? 0,
      "idHotel": _selectedidHotel ?? '',
      "images": [
        {
          "imageData": _image != null ? base64Encode(_image!) : '',
        }
      ],
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print('Room created successfully');

      } else {
        print('Failed to create room: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 40.0),
          // Danh sách khách sạn
          TextButton.icon(
            onPressed: _pickImage,
            icon: const Icon(
              Icons.image,
              size: 60,
            ),
            label: const Text('Chọn ảnh'),
          ),
          if (_image != null)
            // Display the picked image
            Image.memory(_image!),
          const SizedBox(height: 16.0),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Khách sạn',
            ),
            value: _selectedidHotel,
            onChanged: (String? newValue) {
              setState(() {
                _selectedidHotel = newValue;
              });
            },
            items: _idhotel
                .map<DropdownMenuItem<String>>((Map<String, String> hotel) {
              return DropdownMenuItem<String>(
                value: hotel['idHotel'],
                child: Text(hotel['nameHotel']!),
              );
            }).toList(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng chọn khách sạn';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Tên phòng'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập tên phòng';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(labelText: 'Diện tích phòng'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập diện tích';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _peopleController,
            decoration: const InputDecoration(labelText: 'Số nguười'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập số người';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _policyController,
            decoration: const InputDecoration(labelText: 'Chính sách'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập chính sách';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _bedController,
            decoration: const InputDecoration(labelText: 'Số giường'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập số giường';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Loại phòng',
            ),
            value: _selectedRoomType,
            onChanged: (String? newValue) {
              setState(() {
                _selectedRoomType = newValue;
              });
            },
            items: _hotelTypes.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng chọn loại phòng';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _priceController,
            decoration: const InputDecoration(labelText: 'Giá tiền'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập giá tiền';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              _submitForm();
              Navigator.push(context, allHotelsRoute);
            },
            child: const Text('Gửi'),
          ),
        ],
      ),
    ));
  }
}
