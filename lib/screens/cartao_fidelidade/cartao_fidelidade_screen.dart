import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/preferences.dart';
import 'package:loja_virtual/screens/cartao_fidelidade/widgets/card_back_fidelity.dart';
import 'package:loja_virtual/screens/cartao_fidelidade/widgets/card_front_fidelity.dart';

class CardFidelityScreen extends StatelessWidget {
  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  final User user;

  CardFidelityScreen(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text('Cartão Fidelidade'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FlipCard(
                    key: cardKey,
                    flipOnTouch: false,
                    speed: 700,
                    front: CardFrontFidelity(),
                    back: CardBackFidelity()),
                Align(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                      child: Text(
                        'Virar Cartão',
                        style:
                            TextStyle(fontSize: 20, color: corRosa),
                      ),
                      onPressed: () {
                        cardKey.currentState.toggleCard();
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
