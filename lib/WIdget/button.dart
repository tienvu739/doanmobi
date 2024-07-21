import 'package:flutter/material.dart';

class buttonWIdget extends StatelessWidget {
  const buttonWIdget({super.key, required this.title, this.ontap});

  final String title;
  final Function()? ontap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: ontap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            gradient: Gradients.defaultGradientBackground,
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(color: Colors.black),
          ),
        ));
    ;
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
