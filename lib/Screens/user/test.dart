import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:sprintf/sprintf.dart';
import 'package:http/http.dart' as http;

import '../../models/create_order_reponse.dart';

String formatNumber(double value) {
  final f = NumberFormat("#,###", "vi_VN");
  return f.format(value);
}

/// Function Format DateTime to String with layout string
String formatDateTime(DateTime dateTime, String layout) {
  return DateFormat(layout).format(dateTime).toString();
}

int transIdDefault = 1;
String getAppTransId() {
  if (transIdDefault >= 100000) {
    transIdDefault = 1;
  }

  transIdDefault += 1;
  var timeString = formatDateTime(DateTime.now(), "yyMMdd_hhmmss");
  return sprintf("%s%06d", [timeString, transIdDefault]);
}

String getBankCode() => "zalopayapp";

String getDescription() => "Merchant Demo thanh toán cho đơn hàng";

String getMacCreateOrder(String data) {
  var hmac = Hmac(sha256, utf8.encode(ZaloPayConfig.key1));
  return hmac.convert(utf8.encode(data)).toString();
}

class ZaloPayConfig {
  static const String appId = "2553";
  static const String key1 = "PcY4iZIKFCIdgZvA6ueMcMHHUbRLYjPL";
  static const String key2 = "kLtgPl8HHhfvMuDHPwKfgfsY4Ydm9eIz";
  static const String appUser = "zalopaydemo";
}

Future<CreateOrderResponse?> createOrder(int price) async {
  var header = <String, String>{};
  header["Content-Type"] = "application/x-www-form-urlencoded";

  var body = <String, String>{};
  body["app_id"] = ZaloPayConfig.appId;
  body["app_user"] = ZaloPayConfig.appUser;
  body["app_time"] = DateTime.now().millisecondsSinceEpoch.toString();
  body["amount"] = price.toStringAsFixed(0);
  body["app_trans_id"] = getAppTransId();
  body["embed_data"] = "{}";
  body["item"] = "[]";
  body["bank_code"] = getBankCode();
  body["description"] = getDescription();

  var dataGetMac = sprintf("%s|%s|%s|%s|%s|%s|%s", [
    body["app_id"],
    body["app_trans_id"],
    body["app_user"],
    body["amount"],
    body["app_time"],
    body["embed_data"],
    body["item"]
  ]);
  body["mac"] = getMacCreateOrder(dataGetMac);
  print("mac: ${body["mac"]}");

  try {
    http.Response response = await http.post(
      Uri.parse(Endpoints.createOrderUrl),
      headers: header,
      body: body,
    );

    print("body_request: $body");
    if (response.statusCode != 200) {
      return null;
    }

    var data = jsonDecode(response.body);
    print("data_response: $data");

    return CreateOrderResponse.fromJson(data);
  } catch (e) {
    print("Error creating order: $e");
    return null;
  }
}

class Endpoints {
  static const String createOrderUrl = "https://sb-openapi.zalopay.vn/v2/create";
}

class AppConfig {
  static const String appName = "ZaloPay Flutter Demo";
  static const String version = "v2";
}
