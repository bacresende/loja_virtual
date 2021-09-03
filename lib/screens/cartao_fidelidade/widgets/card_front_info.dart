import 'package:flutter/material.dart';
import 'package:loja_virtual/preferences.dart';

class CardFrontInfo extends SingleChildScrollView {
  final String text;
  final String info;
  final IconData icon;

  CardFrontInfo({
    @required this.icon,
    @required this.info,
    @required this.text
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0, left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(this.icon, color: corBranca
              //size: 30,
              ),
          SizedBox(
            width: 5,
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  this.info,
                  style: TextStyle(
                      fontSize: 18,
                      color: corBranca,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  this.text,
                  style: TextStyle(
                      fontSize: 16,
                      color: corBranca,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
