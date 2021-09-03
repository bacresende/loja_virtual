import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:loja_virtual/helpers/moeda_util.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/cart_product.dart';
import 'package:loja_virtual/screens/cart/cart_controller.dart';

class CartTile extends StatelessWidget {
  final CartProduct cartProduct;
  final CartManager cartManager = Get.find();
  final CartController controller;

  CartTile(this.cartProduct, this.controller);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      title: Text(
        cartProduct.product.name,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quantidade: ${cartProduct.quantity}', style: TextStyle(fontSize: 16)),
          Text('R\$ ${MoedaUtil.formatarValor(cartProduct.price)}',
              style: TextStyle(fontSize: 16, color: Colors.green)),
        ],
      ),
      trailing: cartProduct.product.images.isNotEmpty
          ? AspectRatio(
              aspectRatio: 1,
              child: Image.network(cartProduct.product.images.first))
          : AspectRatio(aspectRatio: 1, child: Image.asset('assets/logo.jpeg')),
      onTap: () {
        controller.dialogDeleteItemCart(cartProduct);
      },
    );
  }
}
