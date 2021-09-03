import 'package:flutter/material.dart';
import 'package:loja_virtual/helpers/moeda_util.dart';
import 'package:loja_virtual/models/cart_product.dart';
import 'package:loja_virtual/preferences.dart';
import 'package:loja_virtual/screens/my_orders.dart/widgets/list_adicionais_product.dart';

class ListTileProduct extends StatelessWidget {
  final CartProduct cartProduct;

  ListTileProduct(this.cartProduct);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: cartProduct.product.images.isNotEmpty
              ? SizedBox(
                  height: 60,
                  width: 60,
                  child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.network(cartProduct.product.images.first)),
                )
              : AspectRatio(
                  aspectRatio: 1, child: Image.asset('assets/logo.jpeg')),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cartProduct.product.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'R\$ ${MoedaUtil.formatarValor(cartProduct.price)}',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                cartProduct.product.description,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          subtitle: cartProduct.adicionalProducts.isNotEmpty
              ? ListAdicionaisProduct(cartProduct)
              : Container(),
          trailing: Text(
            'Qtde ${cartProduct.quantity}',
            style: flatMiniButtonPretoStyle,
          ),
        ),
        Divider(),
      ],
    );
  }

  
}
