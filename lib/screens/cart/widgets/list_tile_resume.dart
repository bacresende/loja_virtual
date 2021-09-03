import 'package:flutter/material.dart';
import 'package:loja_virtual/models/adicional_product.dart';
import 'package:loja_virtual/models/cart_product.dart';
import 'package:loja_virtual/preferences.dart';

class ListTileResume extends StatelessWidget {
  final CartProduct cartProduct;

  ListTileResume(this.cartProduct);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(),
        ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                cartProduct.product.name,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              Text(
                'Qtde ${cartProduct.quantity}',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Text(cartProduct.adicionalProducts.length > 0 ? 'Adicionais' : '',
                  style: TextStyle(fontWeight: FontWeight.w600, color: corRosa)),
              Column(
                children: cartProduct.adicionalProducts
                    .map((AdicionalProduct adicionalProduct) => ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('- ${adicionalProduct.name}'),
                              Text('${adicionalProduct.quantity} Unidade '),
                            ],
                          ),
                        ))
                    .toList(),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                  child: Text(
                    'Valor ${cartProduct.price}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: corRosa),
                  ),
                ),
              )
            ],
          ),
        ),
        
      ],
    );
  }
}
