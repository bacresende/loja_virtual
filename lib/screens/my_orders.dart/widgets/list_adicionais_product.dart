import 'package:flutter/material.dart';
import 'package:loja_virtual/helpers/moeda_util.dart';
import 'package:loja_virtual/models/adicional_product.dart';
import 'package:loja_virtual/models/cart_product.dart';
import 'package:loja_virtual/preferences.dart';

class ListAdicionaisProduct extends StatelessWidget {
  final CartProduct cartProduct;

  ListAdicionaisProduct(this.cartProduct);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Adicionais',
            style: TextStyle(color: corRosa),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: cartProduct.adicionalProducts
                .map(
                  (AdicionalProduct adicionalProduct) => Row(
                    children: [
                      Expanded(
                        child: Text(
                            '${adicionalProduct.quantity} - ${adicionalProduct.name}'),
                      ),
                      Text('R\$ ${getPriceAdicional(adicionalProduct)}')
                    ],
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }

  String getPriceAdicional(AdicionalProduct adicionalProduct) {
    double valorAdicional =
        double.parse(adicionalProduct.price) * adicionalProduct.quantity;
    return MoedaUtil.formatarValor('$valorAdicional');
  }
}
