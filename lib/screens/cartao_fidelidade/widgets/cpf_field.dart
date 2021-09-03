import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loja_virtual/models/credit_card.dart';

class CpfField extends StatelessWidget {
  final CreditCard creditCard;

  CpfField({this.creditCard});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.purple[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 16,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CPF',
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: '000.000.000-00',
                hintStyle: TextStyle(color: Colors.white.withAlpha(100)),
              border: InputBorder.none,
                isDense: true
              ),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold),
              keyboardType: TextInputType.number,
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
                CpfInputFormatter()
              ],
              validator: (String cpf){
                if(cpf.isEmpty){
                  return 'campo obrigatório';
                }else if(!GetUtils.isCpf(cpf)){
                  return 'O CPF não existe';
                }

                return null;
              },
              onChanged: creditCard.setCPF,
            )
          ],
        ),
      ),
    );
  }
}
