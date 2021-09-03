import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/cart_product.dart';
import 'package:loja_virtual/models/order.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/preferences.dart';
import 'package:loja_virtual/screens/faturado_mes/widgets/cart_info_value.dart';
import 'package:loja_virtual/screens/my_orders.dart/widgets/list_tile_product.dart';
import 'package:loja_virtual/widgets/info_card.dart';
import 'package:url_launcher/url_launcher.dart';

class FaturadoMesController extends GetxController {
  RxList datas = [].obs;
  Firestore db = Firestore.instance;
  List<Map<String, dynamic>> maps = [];
  FaturadoMesController() {
    _loadFaturados();
  }

  Future<void> _loadFaturados() async {
    DocumentSnapshot documentSnapshot =
        await db.collection('faturamento').document('mes').get();
    datas.value = documentSnapshot.data['datas'];
  }

  Future<void> openMesSelecionadoFaturamento(String data) async {
    QuerySnapshot querySnapshot = await db
        .collection('faturamento')
        .document('mes')
        .collection(data)
        .getDocuments();

    maps = [];
    double valorBruto = 0;
    for (DocumentSnapshot doc in querySnapshot.documents) {
      maps.add(doc.data);
      String valor = doc.data['valor'];
      valor = valor.replaceAll('.', '.').replaceAll(',', '.');
      double valorDouble = double.parse(valor);
      valorBruto += valorDouble;
    }


    double valorLiquido = valorBruto * 0.95;

    double valorRepassar = valorBruto - valorLiquido;

    showModalBottomSheet(
        isScrollControlled: true,
        context: Get.context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(top: 30, right: 5, left: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: corRosa,
                    ),
                    onPressed: () {
                      Get.back();
                    }),
                CardInfoValue(text: 'Bruto', valor: valorBruto),
                CardInfoValue(text: 'Líquido', valor: valorLiquido),
                CardInfoValue(text: 'À repassar', valor: valorRepassar),
                Divider(),
                Expanded(
                  child: ListView.separated(
                      separatorBuilder: (_, __) => Divider(),
                      itemCount: maps.length,
                      itemBuilder: (_, index) {
                        Map<String, dynamic> map = maps[index];
                        return ListTile(
                          title: Text(
                            'R\$ ' + map['valor'],
                            style: flatButtonRosaStyle,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Id do Pedido ${map['idPedido'] ?? 'Sem Id'}'),
                              Text('(Clique para ver detalhe do pedido)'),
                            ],
                          ),
                          onTap: () async {
                            await openOrderById(map['idPedido'].toString());
                          },
                        );
                      }),
                ),
              ],
            ),
          );
        });
  }

  Future<void> openOrderById(String id) async {
    DocumentSnapshot documentSnapshot =
        await db.collection('orders').document(id).get();

    Order order = Order.fromDocument(documentSnapshot);

    showModalBottomSheet(
      isScrollControlled: true,
        context: Get.context,
        builder: (context) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    icon: Icon(Icons.arrow_back, color: corRosa),
                    onPressed: () {
                      Get.back();
                    }),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: ExpansionTile(
                      initiallyExpanded: true,
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
                                      openAddress(order.address);
                                    },
                                  ),
                                  FlatButton(
                                    child: Text(
                                      'Ver Cliente',
                                      style: flatButtonRosaStyle,
                                    ),
                                    onPressed: () async {

                                      await openClient(
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
                )
              ],
            ),
          );
        });
  }

  void openAddress(Address address) {
    
    showModalBottomSheet(
        isScrollControlled: true,
        context: Get.context,
        builder: (context) {
          return Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  InfoCard(
                      text: address.nomeEndereco,
                      info: 'Nome do Endereço',
                      icon: Icons.home),
                  InfoCard(
                      text: address.pontoDeReferencia != ''
                          ? address.pontoDeReferencia
                          : 'Sem Ponto de Referência',
                      info: 'Ponto de Referência',
                      icon: Icons.pin_drop_outlined),
                  InfoCard(
                      text: address.numeroResidencia,
                      info: 'Número da Residência',
                      icon: Icons.format_list_numbered),
                  InfoCard(
                      text: address.complemento != ''
                          ? address.complemento
                          : 'Sem Complemento',
                      info: 'Complemento',
                      icon: Icons.short_text),
                  InfoCard(
                      text: address.bairro,
                      info: 'Bairro',
                      icon: Icons.short_text),
                  InfoCard(
                      text: '${address.cidade} - ${address.estado}',
                      info: 'Cidade/Estado',
                      icon: Icons.short_text),
                  GestureDetector(
                    child: InfoCard(
                        text: address.telefone,
                        info: 'Telefone do Usuário (Clique para Ligar)',
                        icon: Icons.call),
                    onTap: () async {
                      await launch('tel:+55${address.telefone}');
                    },
                  ),
                  GestureDetector(
                    child: InfoCard(
                        text: 'Clique para ver o endeço',
                        info:
                            'Obs: É um endereço aproximado com base no cep do cliente',
                        icon: Icons.map),
                    onTap: () async {
                      String linkMaps =
                          '//www.google.com/maps/place/${address.latitude},${address.longitude}';
                      await launch('https:$linkMaps');
                    },
                  ),
                  GestureDetector(
                    child: Container(
                      color: corRosa,
                      padding: EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Voltar',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Get.back();
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<void> openClient(String idUsuario, Address address) async {
    DocumentSnapshot documentSnapshot =
        await db.collection('users').document(idUsuario).get();
    User user = new User.fromMap(documentSnapshot.data);
  
    await showModalBottomSheet(
        isScrollControlled: true,
        context: Get.context,
        builder: (context) {
          return Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  InfoCard(
                      text: user.name,
                      info: 'Nome do Usuário',
                      icon: Icons.person),
                  InfoCard(
                      text: user.email,
                      info: 'E-mail do Usuário',
                      icon: Icons.email),
                  GestureDetector(
                    child: InfoCard(
                        text: address.telefone,
                        info: 'Telefone do Usuário (Clique para Ligar)',
                        icon: Icons.call),
                    onTap: () async {
                      await launch('tel:+55${address.telefone}');
                    },
                  ),
                  GestureDetector(
                    child: Container(
                      color: corRosa,
                      padding: EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Voltar',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Get.back();
                    },
                  )
                ],
              ),
            ),
          );
        });
  }
}
