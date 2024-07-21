class user {
  user(
      {required this.email,
      required this.matkhau,
      required this.tenkhachhang,
      required this.sdt});
  final String email;
  final String matkhau;
  final String tenkhachhang;
  final int sdt;
  factory user.fromJson(Map<String, dynamic> json) {
    return user(
      email: json['email'] ?? '',
      matkhau: json['matkhau'] ?? '',
      tenkhachhang: json['tenkhachhang'] ?? '',
      sdt: json['sdt'] ?? '',
    );
  }
}
