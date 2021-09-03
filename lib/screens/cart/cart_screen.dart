import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loja_virtual/helpers/moeda_util.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/cart_product.dart';
import 'package:loja_virtual/screens/cart/cart_controller.dart';
import 'package:loja_virtual/screens/cart/widgets/cart_tile.dart';

class CartScreen extends StatelessWidget {
  final CartManager cartManager = Get.find();
  final CartController controller = new CartController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meu Carrinho'),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.remove_shopping_cart_outlined,
                  color: Colors.white),
              tooltip: 'Apagar Carrinho',
              onPressed: () {
                controller.dialogDeleteCart();
              })
        ],
      ),
      body: Obx(() => Column(
            children: [
              Expanded(
                  child: ListView.separated(
                separatorBuilder: (_, index) => Divider(),
                itemCount: cartManager.items.length,
                itemBuilder: (_, index) {
                  CartProduct cartProduct = cartManager.items[index];
                  return CartTile(cartProduct, controller);
                },
              ))
            ],
          )),
      bottomNavigationBar: Obx(() => GestureDetector(
            child: Container(
              color: !controller.loading ? Colors.green : Colors.black,
              padding: EdgeInsets.all(15),
              child: !controller.loading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Avançar',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        Obx(() => Text(
                              'R\$ ' +
                                  MoedaUtil.formatarValor(controller.valor),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            )),
                      ],
                    )
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          'Finalizando Pedido',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),
            ),
            onTap: !controller.loading ?  () async {
              
              controller.openModalEnderecos();
            } : (){},
          )),
    );
  }
}
