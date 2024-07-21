import 'HotelImage.dart';

class Hotel {
  final String idHotel;
  final String nameHotel;
  final String addressHotel;
  final String describeHotel;
  final String policyHotel;
  final String typeHotel;
  final bool statusHotel;
  final List<HotelImage> images;

  Hotel({
    required this.idHotel,
    required this.nameHotel,
    required this.addressHotel,
    required this.describeHotel,
    required this.policyHotel,
    required this.typeHotel,
    required this.statusHotel,
    required this.images,
  });
  factory Hotel.fromJson(Map<String, dynamic> json) {
    var imagesList = json['images'] as List;
    List<HotelImage> imageList =
    imagesList.map((i) => HotelImage.fromJson(i)).toList();

    return Hotel(
      idHotel: json['idHotel'],
      nameHotel: json['nameHotel'],
      addressHotel: json['addressHotel'],
      describeHotel: json['describeHotel'],
      policyHotel: json['policyHotel'],
      typeHotel: json['typeHotel'],
      statusHotel: json['statusHotel'],
      images: imageList,
    );
  }
}