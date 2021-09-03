import 'package:flutter/material.dart';
import 'package:loja_virtual/preferences.dart';

class TextInfo extends StatelessWidget {
  final String title;
  TextInfo(this.title);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, top: 5, bottom: 5),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(this.title,
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w600, color: corRosa),
        ),
      ),
    );
  }
}
