import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/preferences.dart';
import 'package:loja_virtual/screens/product/product_screen.dart';

class ProductListTile extends StatelessWidget {
  final Product product;

  ProductListTile(this.product);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Get.to(ProductScreen(product));
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Container(
            height: 100,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(product.images.first),
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(top: 4),
                      child: Text(
                        'A partir de ',
                        style: TextStyle(color: Colors.grey[400], fontSize: 16),
                      ),
                    ),
                    Text(
                      'R\$ 19.99',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: primaryColor),
                    ),
                  ],
                ))
              ],
            )),
      ),
    );
  }
}
