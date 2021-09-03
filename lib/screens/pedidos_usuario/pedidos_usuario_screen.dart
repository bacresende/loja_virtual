import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:loja_virtual/models/cart_product.dart';
import 'package:loja_virtual/models/order.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/preferences.dart';
import 'package:loja_virtual/screens/my_orders.dart/widgets/list_tile_product.dart';
import 'package:loja_virtual/screens/pedidos_usuario/pedidos_usuario_controller.dart';

class PedidosUsuarioScreen extends StatelessWidget {
  final User user;

  PedidosUsuarioScreen(this.user);
  @override
  Widget build(BuildContext context) {
    PedidosUsuarioController controller = new PedidosUsuarioController(user.id);
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedidos de ${user.name}'),
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
                                  FlatButton(
                                    child: Text(
                                      'Ver Endereço',
                                      style: flatButtonAzulStyle,
                                    ),
                                    onPressed: () {
                                      controller.openAddress(order.address);
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
                  '${user.name} ainda não fez nenhum pedido :(',
                  textAlign: TextAlign.center,
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
