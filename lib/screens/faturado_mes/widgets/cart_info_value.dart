import 'package:flutter/material.dart';
import 'package:loja_virtual/helpers/moeda_util.dart';
import 'package:loja_virtual/preferences.dart';

class CardInfoValue extends StatelessWidget {
  final String text;
  final double valor;

  CardInfoValue({this.text, this.valor});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: corRosa,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          '$text: R\$ ${MoedaUtil.formatarValor('$valor')}',
          style: flatButtonBrancoStyle,
        ),
      ),
    );
  }
}
