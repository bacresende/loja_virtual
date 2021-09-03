import 'package:brasil_fields/brasil_fields.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/models/credit_card.dart';
import 'package:loja_virtual/screens/credit_card/widgets/card_text_field.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CardFront extends StatelessWidget {
  final dateFormatter = MaskTextInputFormatter(
      mask: '!##/##', filter: {'#': RegExp('[0-9]'), '!': RegExp('[0-1]')});

  final FocusNode numberFocus;
  final FocusNode dateFocus;
  final FocusNode nameFocus;
  final VoidCallback finished;
  final CreditCard creditCard;

  CardFront({this.creditCard, this.numberFocus, this.dateFocus, this.nameFocus, this.finished});
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 16,
      color: Colors.purple[900],
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CardTextField(
                    onChanged: creditCard.setNumber,
                    title: 'Número',
                    hint: '0000 0000 0000 0000',
                    textInputType: TextInputType.number,
                    bold: true,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      CartaoBancarioInputFormatter()
                    ],
                    validator: (String cartao) {
                      if (cartao.isEmpty) {
                        return 'Não deixe o campo em branco';
                      } else if (detectCCType(cartao) ==
                          CreditCardType.unknown) {
                        return 'Cartão inválido';
                      } else if (cartao.length != 19) {
                        return 'Cartão inválido';
                      }
                      return null;
                    },
                    focusNode: this.numberFocus,
                    onSubmitted: (_) {
                      
                      this.dateFocus.requestFocus();
                    },
                  ),
                  CardTextField(
                    onChanged: creditCard.setExpirationDate,
                    title: 'Validade',
                    hint: '11/21',
                    textInputType: TextInputType.number,
                    bold: true,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      ValidadeCartaoInputFormatter(),
                    ],
                    validator: (String data) {
                      if (data.isEmpty) {
                        return 'Não deixe o campo em branco';
                      } else if (data.length != 5) {
                        return 'Digite uma data válida';
                      }
                      return null;
                    },
                    focusNode: this.dateFocus,
                    onSubmitted: (_) {
                      this.nameFocus.requestFocus();
                    },
                  ),
                  CardTextField(
                    onChanged: creditCard.setHolder,
                    title: 'Titular',
                    hint: 'Bruno Resende',
                    textInputType: TextInputType.text,
                    validator: (String nome) {
                      if (nome.isEmpty) {
                        return 'Não deixe o campo em branco';
                      }
                      return null;
                    },
                    focusNode: this.nameFocus,
                    onSubmitted: (_) {
                      this.finished();
                      
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.credit_card,
              color: Colors.white,
              size: 50,
            ),
          )
        ],
      ),
    );
  }
}
