import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String titulo;

  CustomText(this.titulo);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        titulo,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
    );
  }
}