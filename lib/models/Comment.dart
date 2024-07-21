class Comment {
  String title;
  String describeEvaluate;
  int point;
  String idHotel;
  String idUser;

  Comment({
    required this.title,
    required this.describeEvaluate,
    required this.point,
    required this.idHotel,
    required this.idUser,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'describeEvaluate': describeEvaluate,
      'point': point,
      'idHotel': idHotel,
      'idUser': idUser,
    };
  }
}
