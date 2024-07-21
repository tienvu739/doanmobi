class Discount {
  final String idDiscount;
  final String nameDiscount;
  final String describeDiscount;
  final int discountAmount;
  final int discountNumber;

  Discount({
    required this.idDiscount,
    required this.nameDiscount,
    required this.describeDiscount,
    required this.discountAmount,
    required this.discountNumber,
  });

  factory Discount.fromJson(Map<String, dynamic> json) {
    return Discount(
      idDiscount: json['idDiscount'],
      nameDiscount: json['nameDiscount'],
      describeDiscount: json['describeDiscount'],
      discountAmount: json['discountAmount'],
      discountNumber: json['discountNumber'],
    );
  }
}
