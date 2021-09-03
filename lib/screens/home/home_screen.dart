import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/helpers/data.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/product_manager.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/preferences.dart';
import 'package:loja_virtual/screens/cart/cart_screen.dart';
import 'package:loja_virtual/screens/edit_days/edit_days_screen.dart';
import 'package:loja_virtual/screens/faturado_mes/faturado_mes_screen.dart';
import 'package:loja_virtual/screens/home/home_controller.dart';
import 'package:loja_virtual/screens/product_detail/product_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  //HomeManager homeManager = Get.find();
  final ProductManager productManager = Get.find();
  final UserManager userManager = Get.find();

  final CartManager cartManager = Get.find();
  final User user;

  HomeScreen(this.user);

  @override
  Widget build(BuildContext context) {
    HomeController controller = new HomeController(this.user);
    if (DataHelper.getWeek() == 'Domingo') {
      return Scaffold(
        appBar: AppBar(
          title: Text('Retornaremos Amanhã!'),
          actions: [
            user.admin
                ? IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Get.to(EditDaysScreen());
                    })
                : Container(),
            user.admin
                ? IconButton(
                    icon: Icon(Icons.monetization_on),
                    onPressed: () {
                      Get.to(FaturadoMesScreen());
                    })
                : Container(),
          ],
        ),
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'Olá! Desculpe, mas não funcionamos em dia de domingo :(',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.pink,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            DataHelper.getWeek(),
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          actions: [
            user.admin
                ? IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Get.to(EditDaysScreen());
                    })
                : Container(),
            user.admin
                ? IconButton(
                    icon: Icon(Icons.monetization_on),
                    onPressed: () {
                      Get.to(FaturadoMesScreen());
                    })
                : Container(),
            user.admin
                ? IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      controller.setEdit();
                    })
                : Container()
          ],
        ),
        drawer: CustomDrawer(),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      controller.textoInformativo,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: corRosa),
                    ),
                  )),
              Obx(() => productManager.allProducts.isEmpty
                  ? Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Sem Produtos hoje'),
                        if (this.user.admin)
                          FlatButton(
                              onPressed: () {
                                Get.to(EditDaysScreen());
                              },
                              child: Text(
                                'Clique Aqui Para Cadastrar',
                                style: flatButtonRosaStyle,
                              ))
                      ],
                    ))
                  : Expanded(
                      child: ListView.separated(
                          separatorBuilder: (_, __) => Divider(),
                          itemCount: productManager.allProducts.length,
                          itemBuilder: (_, index) {
                            Product product = productManager.allProducts[index];

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
                              title: Text(
                                product.name,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(product.description,
                                      style: TextStyle(fontSize: 16)),
                                  Text('R\$ ${product.price}',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.green)),
                                ],
                              ),
                              trailing: product.images.isNotEmpty
                                  ? AspectRatio(
                                      aspectRatio: 1,
                                      child:
                                          Image.network(product.images.first))
                                  : AspectRatio(
                                      aspectRatio: 1,
                                      child: Image.asset('assets/logo.jpeg')),
                              onTap: () {
                                Get.to(ProductDetailScreen(product),
                                    transition: Transition.rightToLeft);
                              },
                            );
                          }),
                    )),
            ],
          ),
        ),
        bottomNavigationBar: Obx(() => cartManager.items.length > 0
            ? GestureDetector(
                child: Container(
                  color: Colors.green,
                  padding: EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Ver Carrinho ',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 10),
                        child: Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          '${cartManager.items.length} Ite${cartManager.items.length > 1 ? 'ns' : 'm'}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Get.to(CartScreen());
                },
              )
            : Container(
                height: 0,
              )));
  }
}
