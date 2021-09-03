import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/order.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/preferences.dart';
import 'package:loja_virtual/widgets/info_card.dart';
import 'package:url_launcher/url_launcher.dart';

class OrdersUsersController extends GetxController {
  RxList<Order> orders = <Order>[].obs;

  RxString _statusSelecionado = ''.obs;

  String get statusSelecionado => _statusSelecionado.value;

  RxBool _alterStatus = false.obs;

  bool get alterStatus => _alterStatus.value;

  set alterStatus(bool value)=> _alterStatus.value = value;

  set statusSelecionado(String value) => _statusSelecionado.value = value;
  Firestore db = Firestore.instance;

  OrdersUsersController() {
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    Firestore db = Firestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await auth.currentUser();

    if (firebaseUser != null) {
      db.collection('orders').snapshots().listen((querySnapshot) {
        orders.value =
            querySnapshot.documents.map((e) => Order.fromDocument(e)).toList();

        orders.sort((Order a, Order b) => b.orderId.compareTo(a.orderId));
      });
    }
  }

  Future<void> alterarStatus(Order order) async {
    statusSelecionado = order.status;

    //Pedido Recebido, Pedido em Preparo, Saiu para Entrega, Pedido Entregue, Cancelado
    await showModalBottomSheet(
        isScrollControlled: true,
        context: Get.context,
        builder: (context) {
          return Container(
            child: SingleChildScrollView(
              child: Obx(() => Column(
                    children: [
                      RadioListTile(
                        title: Text(
                          'Cancelado',
                          style: flatButtonVermelhoStyle2,
                        ),
                        value: 'Cancelado',
                        groupValue: statusSelecionado,
                        onChanged: (String status) {
                          statusSelecionado = status;
                        },
                      ),
                      Divider(),
                      Container(
                        height: 20,
                      ),
                      RadioListTile(
                        title: Text(
                          'Pedido Recebido',
                          style: flatButtonAzulStyle,
                        ),
                        value: 'Pedido Recebido',
                        groupValue: statusSelecionado,
                        onChanged: (String status) {
                          statusSelecionado = status;
                        },
                      ),
                      RadioListTile(
                        title: Text(
                          'Pedido em Preparo',
                          style: flatButtonAzulStyle,
                        ),
                        value: 'Pedido em Preparo',
                        groupValue: statusSelecionado,
                        onChanged: (String status) {
                          statusSelecionado = status;
                        },
                      ),
                      RadioListTile(
                        title: Text(
                          'Saiu Para Entrega',
                          style: flatButtonAzulStyle,
                        ),
                        value: 'Saiu Para Entrega',
                        groupValue: statusSelecionado,
                        onChanged: (String status) {
                          statusSelecionado = status;
                        },
                      ),
                      RadioListTile(
                        title: Text(
                          'Pedido Entregue',
                          style: flatButtonAzulStyle,
                        ),
                        value: 'Pedido Entregue',
                        groupValue: statusSelecionado,
                        onChanged: (String status) {
                          statusSelecionado = status;
                        },
                      ),
                      Obx(() => GestureDetector(
                            child: Container(
                              color: !alterStatus ? corRosa : Colors.black,
                              padding: EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    !alterStatus ? 'Alterar Status' : 'Alterando Status',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            onTap: !alterStatus ? () async {
                              alterStatus = true;
                              await setStatus(order);

                              if (statusSelecionado == 'Pedido Entregue') {
                                await setFaturamento(order);
                                await addCupomFidelity(order);
                              }
                              Get.back();
                              alterStatus = false;
                            } : (){},
                          ))
                    ],
                  )),
            ),
          );
        });
  }

  Future<void> setStatus(Order order) async {
    db
        .collection('orders')
        .document(order.orderId.toString())
        .updateData({'status': statusSelecionado});
  }

  Future<void> setFaturamento(Order order) async {
    DateTime dateTime = DateTime.now();
    String mesAno = '${dateTime.month}-${dateTime.year}';
    db
        .collection('faturamento')
        .document('mes')
        .collection(mesAno)
        .add({'valor': order.valorTotal, 'idPedido': order.orderId});

    DocumentSnapshot documentSnapshot =
        await db.collection('faturamento').document('mes').get();
    List datas = [];

    datas = documentSnapshot.data['datas'];

    if (!datas.contains(mesAno)) {
      datas.add(mesAno);
      await db
          .collection('faturamento')
          .document('mes')
          .setData({'datas': datas});
    }
  }

  Future<void> addCupomFidelity(Order order) async {
    String valorString = order.valorTotal;

    valorString = valorString.replaceAll('.', '');
    valorString = valorString.replaceAll(',', '.');

    double valor = double.parse(valorString);
    double valorCupom = valor * 0.1;
    await db
        .collection('users')
        .document(order.idUsuario)
        .collection('cardFidelity')
        .add({'value': valorCupom.toStringAsFixed(2)});

    await verifyTotalPointsCupom(order);
  }

  Future<void> verifyTotalPointsCupom(Order order) async {
    QuerySnapshot querySnapshot = await db
        .collection('users')
        .document(order.idUsuario)
        .collection('cardFidelity')
        .getDocuments();
    if (querySnapshot.documentChanges.length >= 10) {
      await db.collection('users').document(order.idUsuario).updateData(
          {'data_valid_fidelity': DateTime.now().add(Duration(days: 30))});
    }
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
    Firestore db = Firestore.instance;
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
