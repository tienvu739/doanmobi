import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

import '../hoteler.dart';

class addHotelerScreenHotel extends StatefulWidget {
  const addHotelerScreenHotel({super.key});

  @override
  State<addHotelerScreenHotel> createState() => _addHotelerScreenHotelState();
}

class _addHotelerScreenHotelState extends State<addHotelerScreenHotel> {
  Uint8List? _image;
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _describeController = TextEditingController();
  final _policyController = TextEditingController();

  List<dynamic> _services = [];
  List<String> _selectedServices = [];
  final List<String> _hotelTypes = ['Khách sạn', 'Nhà nghỉ'];
  String? _selectedHotelType;

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

  Future<void> _submitForm() async {
    final url = Uri.parse('https://10.0.2.2:7226/api/Hotel/addHotel');

    // Lấy token và id từ SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    final id = prefs.getString('auth_id') ?? '';

    // Chuẩn bị thân yêu cầu
    final requestBody = {
      "nameHotel": _nameController.text,
      "addressHotel": _addressController.text,
      "describeHotel": _describeController.text,
      "policyHotel": _policyController.text,
      "typeHotel": _selectedHotelType,
      "statusHotel": false,
      "idHotelier": id,
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
        final hotelId = jsonDecode(response.body)['idHotel']; // Assuming the API returns the created hotel ID
        await _submitServices(hotelId);
        print('Hotel created successfully');
      } else {
        print('Failed to create hotel: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _submitServices(String hotelId) async {
    final url = Uri.parse('https://10.0.2.2:7226/api/Service/addHotelService');

    for (String serviceId in _selectedServices) {
      final requestBody = {
        "idService": serviceId,
        "idHotel": hotelId,
      };

      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(requestBody),
        );

        if (response.statusCode == 200) {
          print('Service added successfully');
        } else {
          print('Failed to add service: ${response.body}');
        }
      } catch (error) {
        print('Error: $error');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  Future<void> _fetchServices() async {
    final url = Uri.parse('https://10.0.2.2:7226/api/Service/dsServicer');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _services = data;
        });
      } else {
        print('Failed to fetch services');
      }
    } catch (error) {
      print('Error decoding services: $error');
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
              icon: const Icon(Icons.image, size: 60,),
              label: const Text('Chọn ảnh'),
            ),
            if (_image != null)
              Image.memory(_image!),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Tên khách sạn'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập tên khách sạn';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Địa chỉ'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập địa chỉ';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _describeController,
              decoration: const InputDecoration(labelText: 'Mô tả'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập mô tả';
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
            const SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Loại hình khách sạn',
              ),
              value: _selectedHotelType,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedHotelType = newValue;
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
                  return 'Vui lòng chọn loại hình khách sạn';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            Text('Dịch vụ', style: TextStyle(fontSize: 16.0)),
            ..._services.map((service) {
              return CheckboxListTile(
                title: Text(service['nameService']),
                value: _selectedServices.contains(service['idService']),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      _selectedServices.add(service['idService']);
                    } else {
                      _selectedServices.remove(service['idService']);
                    }
                  });
                },
              );
            }).toList(),
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
      ),
    );
  }
}
