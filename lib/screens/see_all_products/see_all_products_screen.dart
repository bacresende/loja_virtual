import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/preferences.dart';
import 'package:loja_virtual/screens/product_detail/product_detail_screen.dart';
import 'package:loja_virtual/screens/see_all_products/see_all_products_controller.dart';

class SeeAllProductsSreen extends StatelessWidget {
  final SeeAllProductsController controller = new SeeAllProductsController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todos os produtos'),
        actions: [
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                controller.setEdit();
              })
        ],
      ),
      body: Obx(
        () => controller.allProducts.isEmpty
            ? Center(
                child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Sem Produtos Cadastrados'),
                    FlatButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text(
                          'Clique Aqui Para Cadastrar',
                          style: flatButtonRosaStyle,
                        ))
                  ],
                ),
              ))
            : ListView.separated(
                separatorBuilder: (_, __) => Divider(),
                itemCount: controller.allProducts.length,
                itemBuilder: (_, index) {
                  Product product = controller.allProducts[index];

                  return ListTile(
                    leading: Obx(() => controller.edit
                        ? IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: corVermelha,
                            ),
                            onPressed: () {
                              
                              controller.editItem(product);
                            },
                          )
                        : Container(
                            width: 0,
                            height: 0,
                          )),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          product.dayOfWeek,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.description,
                            style: TextStyle(fontSize: 16)),
                        Text('R\$ ${product.price}',
                            style:
                                TextStyle(fontSize: 16, color: Colors.green)),
                      ],
                    ),
                    trailing: product.images.isNotEmpty
                        ? AspectRatio(
                            aspectRatio: 1,
                            child: Image.network(product.images.first))
                        : AspectRatio(
                            aspectRatio: 1,
                            child: Image.asset('assets/logo.jpeg')),
                    onTap: () {
                      Get.to(ProductDetailScreen(product),
                          transition: Transition.rightToLeft);
                    },
                  );
                }),
      ),
    );
  }
}
