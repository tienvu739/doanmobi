import 'package:doanmobi/Screens/home.dart';
import 'package:doanmobi/Screens/login.dart';
import 'package:doanmobi/Screens/select.dart';

import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> route = {
  homeScreen.routeName: (context) => homeScreen(),
  loginScreen.routeName: (context) => loginScreen(),
  select.routeName:(context) => select()
};
