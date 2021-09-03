import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/order.dart';
import 'package:loja_virtual/preferences.dart';
import 'package:loja_virtual/widgets/info_card.dart';

class PedidosUsuarioController extends GetxController {
  RxList<Order> orders = <Order>[].obs;
  String idUsuario;

  PedidosUsuarioController(this.idUsuario) {
    _loadUserOrders();
  }

  Future<void> _loadUserOrders() async {
    Firestore db = Firestore.instance;

    QuerySnapshot querySnapshot = await db
        .collection('orders')
        .where('idUsuario', isEqualTo: this.idUsuario)
        .getDocuments();

    orders.value =
          querySnapshot.documents.map((e) => Order.fromDocument(e)).toList();

      orders.sort((Order a, Order b) => b.orderId.compareTo(a.orderId));
  }

  openAddress(Address address) {
    
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
                  InfoCard(
                      text: address.telefone,
                      info: 'Telefone',
                      icon: Icons.call),
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
