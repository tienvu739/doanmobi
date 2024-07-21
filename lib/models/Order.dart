class Order {
  final String dateCreated;
  final String checkInDate;
  final String checkOutDate;
  final double price;
  final String idUser;
  final String idDiscount;
  final String idRoom;

  Order({
    required this.dateCreated,
    required this.checkInDate,
    required this.checkOutDate,
    required this.price,
    required this.idUser,
    required this.idDiscount,
    required this.idRoom,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      dateCreated: json['dateCreated'],
      checkInDate: json['checkInDate'],
      checkOutDate: json['checkOutDate'],
      price: json['price'],
      idUser: json['idUser'],
      idDiscount: json['idDiscount'],
      idRoom: json['idRoom'],
    );
  }
}
