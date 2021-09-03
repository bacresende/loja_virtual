import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  CustomIconButton({this.icon, this.color, this.onTap});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(
              this.icon,
              color: this.color,
            ),
          ),
          onTap: this.onTap,
        ),
      ),
    );
  }
}
