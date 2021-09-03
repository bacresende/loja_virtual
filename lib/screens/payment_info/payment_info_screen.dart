import 'package:flutter/material.dart';
import 'package:loja_virtual/preferences.dart';

class PaymentInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Problemas Técnicos'),
        centerTitle: true,
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Desculpe, o app está passando por problemas técnicos :(',
                textAlign: TextAlign.center,
                style: flatButtonRosaStyle,
              ),
              SizedBox(height: 20),
              Text(
                'Retorne daqui uns instantes',
                textAlign: TextAlign.center,
                style: flatButtonCinzaStyle,
              )
            ],
          ),
        ),
      ),
    );
  }
}
