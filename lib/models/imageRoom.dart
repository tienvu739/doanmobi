class ImageRoom {
  final String idImageRoom;
  final String imageData;

  ImageRoom({
    required this.idImageRoom,
    required this.imageData,
  });

  factory ImageRoom.fromJson(Map<String, dynamic> json) {
    return ImageRoom(
      idImageRoom: json['idImageRoom'],
      imageData: json['imageData'],
    );
  }
}