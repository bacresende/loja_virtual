import 'package:flutter/material.dart';

class ElegantButton extends StatelessWidget {
  ElegantButton(
      {Key key,
      this.action,
      @required this.label,
      this.color = Colors.pink,
      this.textStyle,
      this.width = 320})
      : super(key: key);
  final String label;
  final Color color;
  final TextStyle textStyle;
  final VoidCallback action;
  final double width;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: Container(
        width: width,
        height: 50,
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      onPressed: action,
    );
  }
}
