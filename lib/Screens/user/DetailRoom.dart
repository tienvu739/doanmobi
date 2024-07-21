import 'dart:convert';

import 'package:doanmobi/models/room.dart';
import 'package:flutter/material.dart';

import 'PaymentPage.dart';

class DetailRoom extends StatelessWidget {
  const DetailRoom({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: room.imageRooms.isNotEmpty
                ? Image.memory(
              base64Decode(room.imageRooms[0].imageData),
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height * 0.4,
              width: double.infinity,
              alignment: Alignment.center,
            )
                : Image.network(
              'https://via.placeholder.com/150',
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height * 0.4,
              width: double.infinity,
              alignment: Alignment.center,
            ),
          ),
          Positioned(
            top: 72.0,
            left: 24.0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  color: Colors.white,
                ),
                child: Icon(Icons.arrow_back),
              ),
            ),
          ),
          Positioned(
            top: 72.0,
            right: 24.0,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  color: Colors.white,
                ),
                child: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.4,
            maxChildSize: 0.8,
            minChildSize: 0.4,
            builder: (context, scrollController) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32.0),
                    topRight: Radius.circular(32.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 16.0),
                      child: Container(
                        height: 5,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        children: [
                          Text(
                            room.nameRoom,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 32),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Row(
                            children: [
                              Icon(Icons.crop, size: 20),
                              SizedBox(width: 5.0),
                              Text(
                                'Diện tích: ${room.areaRoom} m²',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Row(
                            children: [
                              Icon(Icons.people, size: 20),
                              SizedBox(width: 5.0),
                              Text(
                                'Số người: ${room.people}',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Row(
                            children: [
                              Icon(Icons.bed, size: 20),
                              SizedBox(width: 5.0),
                              Text(
                                'Số giường: ${room.bedNumber}',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Row(
                            children: [
                              Icon(Icons.category, size: 20),
                              SizedBox(width: 5.0),
                              Text(
                                'Loại phòng: ${room.typeRoom}',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Text(
                            'Chính sách:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text(
                            room.policyRoom,
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Row(
                            children: [
                              Icon(Icons.money, size: 20),
                              SizedBox(width: 5.0),
                              Text(
                                'Giá tiền: ${room.price} VNĐ',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.red),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentPage(
                                    roomId: room.idRoom,
                                    pricePerNight: room.price.toDouble(),
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              textStyle: TextStyle(fontSize: 20),
                            ),
                            child: Center(
                              child: Text('Đặt phòng'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
