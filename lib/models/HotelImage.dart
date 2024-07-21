class HotelImage {
  final String idImageHotel;
  final String imageData;

  HotelImage({required this.idImageHotel, required this.imageData});

  factory HotelImage.fromJson(Map<String, dynamic> json) {
    return HotelImage(
      idImageHotel: json['idImageHotel'],
      imageData: json['imageData'],
    );
  }
}