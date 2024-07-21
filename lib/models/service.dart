class Service {
  final String idService;
  final String nameService;

  Service({required this.idService, required this.nameService});

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      idService: json['idService'],
      nameService: json['nameService'],
    );
  }
}
