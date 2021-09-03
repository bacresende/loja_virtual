import 'package:flutter/material.dart';
import 'package:loja_virtual/preferences.dart';

class InfoCard extends StatelessWidget {
  final String text;
  final String info;
  final IconData icon;
  final Color color;
  final double fontSize;

  const InfoCard(
      {Key key,
      @required this.text,
      @required this.info,
      @required this.icon,
      this.color = Colors.grey,
      this.fontSize = 16
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0, left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(this.icon, color: this.color
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
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  '$text',
                  style: TextStyle(
                      fontSize: this.fontSize,
                      color: corRosa,
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
