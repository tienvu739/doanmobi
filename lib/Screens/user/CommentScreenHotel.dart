import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/Evaluate.dart';

class CommentCreenHotel extends StatefulWidget {
  final String hotelId;

  const CommentCreenHotel({super.key, required this.hotelId});

  @override
  State<CommentCreenHotel> createState() => _CommentCreenHotelState();
}

class _CommentCreenHotelState extends State<CommentCreenHotel> {
  late Future<List<Evaluate>> futureEvaluates;

  Future<List<Evaluate>> fetchEvaluates(String idHotel) async {
    final response = await http.get(Uri.parse('https://10.0.2.2:7226/api/Evaluate/getEvaluatesByHotel?idhotel=$idHotel'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((evaluate) => Evaluate.fromJson(evaluate)).toList();
    } else {
      throw Exception('Failed to load evaluates');
    }
  }

  @override
  void initState() {
    super.initState();
    futureEvaluates = fetchEvaluates(widget.hotelId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bình luận'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Evaluate>>(
        future: futureEvaluates,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Không có đánh giá nào cho khách sạn này.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có đánh giá nào cho khách sạn này.'));
          } else {
            return ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Evaluate evaluate = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          evaluate.title,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(evaluate.describeEvaluate),
                        SizedBox(height: 8.0),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber),
                            SizedBox(width: 5.0),
                            Text(
                              evaluate.point.toString(),
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Ngày tạo: ${evaluate.dateCreated.toLocal().toString().split(' ')[0]}',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
