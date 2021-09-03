import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/models/cart_product.dart';
import 'package:loja_virtual/models/order.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/preferences.dart';
import 'package:loja_virtual/screens/my_orders.dart/widgets/list_tile_product.dart';
import 'package:loja_virtual/screens/orders_users/orders_users_controller.dart';

class OrdersUsersScreen extends StatelessWidget {
  final OrdersUsersController controller = new OrdersUsersController();
  final User user;
  OrdersUsersScreen(this.user);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title:
            Obx(() => Text('Pedido dos Usuários ${controller.orders.length}')),
        centerTitle: true,
      ),
      body: Obx(() => controller.orders.length > 0
          ? ListView.builder(
              itemCount: controller.orders.length,
              itemBuilder: (_, index) {
                Order order = controller.orders[index];
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: ExpansionTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pedido #${order.orderId}',
                                style: flatButtonRosaStyle,
                              ),
                              Text(
                                'R\$ ${order.valorTotal}',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          Text(
                            order.status,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: order.status != 'Cancelado'
                                    ? Colors.blue
                                    : Colors.red[800]),
                          ),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Pago no ${order.pagamentoSelecionado}',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      children: [
                        Column(
                          children: [
                            Column(
                              children: order.items
                                  .map((CartProduct cartProduct) =>
                                      ListTileProduct(cartProduct))
                                  .toList(),
                            ),
                            Container(
                              height: 50,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  order.status !=
                                          'Pedido Entregue'
                                      ? FlatButton(
                                          child: Text(
                                            'Alterar Status',
                                            style: flatButtonVerdeStyle,
                                          ),
                                          onPressed: () {
                                            controller.alterarStatus(order);
                                          },
                                        )
                                      : Container(),
                                  FlatButton(
                                    child: Text(
                                      'Ver Endereço',
                                      style: flatButtonAzulStyle,
                                    ),
                                    onPressed: () {
                                      controller.openAddress(order.address);
                                    },
                                  ),
                                  FlatButton(
                                    child: Text(
                                      'Ver Cliente',
                                      style: flatButtonRosaStyle,
                                    ),
                                    onPressed: () async {

                                      await controller.openClient(
                                          order.idUsuario, order.address);
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              })
          : Container(
              child: Center(
                child: Text(
                  'Sem Pedidos no Momento',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ),
            )),
    );
  }
}
