class Evaluate {
  final String idEvaluate;
  final DateTime dateCreated;
  final String title;
  final String describeEvaluate;
  final double point;
  final String idHotel;
  final String idUser;

  Evaluate({
    required this.idEvaluate,
    required this.dateCreated,
    required this.title,
    required this.describeEvaluate,
    required this.point,
    required this.idHotel,
    required this.idUser,
  });

  factory Evaluate.fromJson(Map<String, dynamic> json) {
    return Evaluate(
      idEvaluate: json['idEvaluate'],
      dateCreated: DateTime.parse(json['dateCreated']),
      title: json['title'],
      describeEvaluate: json['describeEvaluate'],
      point: json['point'].toDouble(),
      idHotel: json['idHotel'],
      idUser: json['idUser'],
    );
  }
}
