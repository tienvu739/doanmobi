import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class appBar extends StatelessWidget {
  const appBar(
      {super.key,
      required this.child,
      this.title,
      this.titleString,
      this.implementLeaning = false,
      this.implemenTraling = false});
  final Widget child;
  final Widget? title;
  final String? titleString;
  final bool implementLeaning;
  final bool implemenTraling;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: 186,
            child: AppBar(
              centerTitle: true,
              automaticallyImplyLeading: false,
              elevation: 0,
              toolbarHeight: 186,
              backgroundColor: Colors.white,
              title: title ??
                  Row(
                    children: [
                      if (implementLeaning)
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0)),
                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 18.0,
                          ),
                        ),
                      Expanded(
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                titleString ?? '',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                      if (implemenTraling)
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0)),
                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: const Icon(
                            Icons.add_alert,
                            color: Colors.black,
                            size: 18.0,
                          ),
                        ),
                    ],
                  ),
              flexibleSpace: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        gradient: Gradients.defaultGradientBackground,
                        borderRadius:
                            BorderRadius.only(bottomLeft: Radius.circular(45))),
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 146),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: child,
          )
        ],
      ),
    );
  }
}

class Gradients {
  static const Gradient defaultGradientBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomLeft,
    colors: [
      Color(0xff8F67E8),
      Color(0xff6155CC),
    ],
  );
}
