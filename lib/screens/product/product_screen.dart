import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/preferences.dart';
import 'package:loja_virtual/screens/cart/cart_screen.dart';
import 'package:loja_virtual/screens/product/widgets/custom_text.dart';

class ProductScreen extends StatelessWidget {
  final Product product;
  final UserManager userManager = Get.find();
  final CartManager cartManager = Get.find();

  ProductScreen(this.product);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(product.name),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Carousel(
                images: product.images
                    .map((String imagem) => NetworkImage(imagem))
                    .toList(),
                dotSize: 4,
                dotBgColor: Colors.transparent,
                dotIncreasedColor: primaryColor,
                autoplay: false,
                dotSpacing: 15,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'A partir de',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ),
                  Text(
                    'R\$ 19,99',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryColor),
                  ),
                  CustomText('Descrição'),
                  Text(
                    product.description,
                    style: TextStyle(fontSize: 18),
                  )
                ],
              ),
            )
          ],
        ),
        bottomNavigationBar: SizedBox(
          height: 44,
          child: RaisedButton(
              child: Text(
                userManager.isLoggedIn
                    ? 'Adicionar ao carrinho'
                    : 'Entre para Comprar',
                style: TextStyle(fontSize: 18),
              ),
              color: primaryColor,
              textColor: Colors.white,
              onPressed: () { 
                Get.to(CartScreen());
              }),
        ));
  }
}
