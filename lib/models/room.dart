import 'imageRoom.dart';

class Room {
  final String idRoom;
  final String nameRoom;
  final int areaRoom;
  final int people;
  final String policyRoom;
  final int bedNumber;
  final bool statusRoom;
  final String typeRoom;
  final int price;
  final String idHotel;
  final List<ImageRoom> imageRooms;

  Room({
    required this.idRoom,
    required this.nameRoom,
    required this.areaRoom,
    required this.people,
    required this.policyRoom,
    required this.bedNumber,
    required this.statusRoom,
    required this.typeRoom,
    required this.price,
    required this.idHotel,
    required this.imageRooms,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    var imagesList = json['imageroms'] as List;
    List<ImageRoom> imageList =
    imagesList.map((e) => ImageRoom.fromJson(e)).toList();
    return Room(
      idRoom: json['idRoom'],
      nameRoom: json['nameRoom'],
      areaRoom: json['areaRoom'],
      people: json['people'],
      policyRoom: json['policyRoom'],
      bedNumber: json['bedNumber'],
      statusRoom: json['statusRoom'],
      typeRoom: json['typeRoom'],
      price: json['price'],
      idHotel: json['idHotel'],
      imageRooms: imageList,
    );
  }
  Room copyWith({bool? statusRoom}) {
    return Room(
      idRoom: idRoom,
      nameRoom: nameRoom,
      areaRoom: areaRoom,
      people: people,
      policyRoom: policyRoom,
      bedNumber: bedNumber,
      statusRoom: statusRoom ?? this.statusRoom,
      typeRoom: typeRoom,
      price: price,
      idHotel: idHotel,
      imageRooms: imageRooms,
    );
  }
}