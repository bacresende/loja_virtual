import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/models/credit_card.dart';
import 'package:loja_virtual/screens/credit_card/widgets/card_text_field.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CardBack extends StatelessWidget {
  final cvvFormatter =
      MaskTextInputFormatter(mask: '###', filter: {'#': RegExp('[0-9]')});

  final FocusNode cvvFocus;
  final CreditCard creditCard;

  CardBack({this.creditCard, this.cvvFocus});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 16,
      color: Colors.purple[900],
      child: Container(
        height: 200,
        child: Column(
          children: [
            Container(
              color: Colors.black,
              height: 40,
              margin: EdgeInsets.symmetric(vertical: 16),
            ),
            Row(
              children: [
                Expanded(
                    flex: 70,
                    child: CardTextField(
                      onChanged: creditCard.setCVV,
                      hint: '123',
                      textAlign: TextAlign.end,
                      textInputType: TextInputType.number,
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly,
                        cvvFormatter,
                      ],
                      focusNode: this.cvvFocus,
                      onSubmitted: (_){},
                      validator: (String cvv){
                        if(cvv.isEmpty ){
                          return 'Campo Obrigatório';
                        }

                        return null;
                      },
                    )),
                Expanded(flex: 30, child: Container()),
              ],
            )
          ],
        ),
      ),
    );
  }
}
