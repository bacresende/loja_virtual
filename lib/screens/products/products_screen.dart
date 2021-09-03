import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/product_manager.dart';
import 'package:loja_virtual/preferences.dart';
import 'package:loja_virtual/screens/cart/cart_screen.dart';
import 'package:loja_virtual/screens/products/widgets/product_list_tile.dart';
import 'package:loja_virtual/screens/products/widgets/search_dialog.dart';

class ProductsScreen extends StatelessWidget {
  final ProductManager productManager = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Obx(() => productManager.search.isEmpty
            ? Text('Produtos')
            : LayoutBuilder(
                builder: (_, constraints) {
                  return GestureDetector(
                    child: Container(
                        width: constraints.biggest.width,
                        child: Text(productManager.search)),
                    onTap: () async {
                      final String search = await showDialog<String>(
                          context: context,
                          builder: (context) =>
                              SearchDialog(productManager.search));

                      if (search != null) {
                        productManager.search = search;
                      }
                    },
                  );
                },
              )),
        centerTitle: true,
        actions: [
          Obx(() => productManager.search.isEmpty
              ? IconButton(
                  icon: Icon(Icons.search, color: Colors.white),
                  onPressed: () async {
                    final String search = await showDialog<String>(
                        context: context,
                        builder: (context) => SearchDialog(''));

                    if (search != null) {
                      productManager.search = search;
                    }
                  })
              : IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    productManager.search = '';
                  }))
        ],
      ),
      body: Container(
        child: Obx(() {
          final filteredProducts = productManager.filteredProducts;
          if (filteredProducts.length != 0) {
            return ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (_, index) {
                Product product = filteredProducts[index];
                return ProductListTile(product);
              },
            );
          } else {
            return Center(
              child: Card(
                margin: EdgeInsets.symmetric(horizontal: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sem itens com a palavra "${productManager.search}"',
                        style: TextStyle(fontSize: 25, color: Colors.grey[400]),
                      ),
                      FlatButton(
                          child: Text(
                            'Clique para voltar a lista',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: primaryColor),
                          ),
                          onPressed: () {
                            productManager.search = '';
                          })
                    ],
                  ),
                ),
              ),
            );
          }
        }),
      ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.white,
          foregroundColor: primaryColor,
          icon: Icon(Icons.shopping_cart),
          label: Text('Ver Carrinho'),
          onPressed: () {
            Get.to(CartScreen());
          }),
    );
  }
}
