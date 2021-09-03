import 'package:flutter/material.dart';

class ElegantDialog extends StatelessWidget {
  final String titulo;
  final String descricao;
  final FlatButton primeiroBotao;
  final FlatButton segundoBotao;
  final IconData icone;
  final Color corDeFundo;

  ElegantDialog({
    @required this.titulo,
    @required this.descricao,
    @required this.primeiroBotao,
    @required this.segundoBotao,
    @required this.icone,
    this.corDeFundo

  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: <Widget>[
          //...bottom card part,
          Container(
            padding: EdgeInsets.only(
              top: 66.0,
              bottom: 16,
              left: 16,
              right: 16,
            ),
            margin: EdgeInsets.only(top: 66),
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                Text(
                  this.titulo,
                  style: TextStyle(
                      fontSize: 25.0, fontFamily: 'Pero', color: Colors.pink),
                ),
                SizedBox(height: 16.0),
                Text(
                  this.descricao,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: 'Regular',
                  ),
                ),
                SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: this.primeiroBotao),
                    Container(
                        height: 25, child: VerticalDivider(color: Colors.pink)),
                    Expanded(child: this.segundoBotao),
                    
                  ],
                ),
              ],
            ),
          ),
          //...top circlular image part,
          Positioned(
            left: 16,
            right: 16,
            child: CircleAvatar(
              backgroundColor: Colors.pink,
              child: Icon(
                this.icone,
                color: Colors.white,
                size: 45,
              ),
              radius: 50,
            ),
          ),
        ],
      ),
    );
  }
}