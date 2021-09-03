import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/models/credit_card.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/screens/credit_card/credit_card_controller.dart';
import 'package:loja_virtual/screens/credit_card/widgets/card_back.dart';
import 'package:loja_virtual/screens/credit_card/widgets/card_front.dart';
import 'package:loja_virtual/screens/credit_card/widgets/cpf_field.dart';

class CreditCardScreen extends StatelessWidget {
  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final CreditCardController controller = new CreditCardController();

  final FocusNode numberFocus = new FocusNode();
  final FocusNode dateFocus = new FocusNode();
  final FocusNode nameFocus = new FocusNode();
  final FocusNode cvvFocus = new FocusNode();
  final CreditCard creditCard = new CreditCard();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text('Cartão de Crédito'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FlipCard(
                      key: cardKey,
                      flipOnTouch: false,
                      speed: 700,
                      front: CardFront(
                        creditCard: this.creditCard,
                        numberFocus: this.numberFocus,
                        dateFocus: this.dateFocus,
                        nameFocus: this.nameFocus,
                        finished: () {
                          this.cardKey.currentState.toggleCard();
                          this.cvvFocus.requestFocus();
                        },
                      ),
                      back: CardBack(
                        creditCard: this.creditCard,
                        cvvFocus: this.cvvFocus,
                      )),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                        child: Text(
                          'Virar Cartão',
                          style: TextStyle(
                              fontSize: 20, color: Colors.purple[900]),
                        ),
                        onPressed: () {
                          cardKey.currentState.toggleCard();
                        }),
                  ),
                  CpfField(creditCard: creditCard),
                  SizedBox(
                    height: 100,
                  ),
                  FlatButton(
                      child: Text(
                        'Verificar',
                        style:
                            TextStyle(fontSize: 20, color: Colors.purple[900]),
                      ),
                      onPressed: () async {

                        if (formKey.currentState.validate()) {
                          
                          
                          await controller.checkout(this.creditCard);
                        }
                      }),
                  FlatButton(
                      child: Text(
                        'Cancelar Compra',
                        style:
                            TextStyle(fontSize: 20, color: Colors.purple[900]),
                      ),
                      onPressed: () async {
                        await controller.cancelPay();
                      }),
                  FlatButton(
                      child: Text(
                        'Gerar Token',
                        style:
                            TextStyle(fontSize: 20, color: Colors.purple[900]),
                      ),
                      onPressed: () async {
                        User user = new User();
                        await user.saveToken();
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
