import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/order.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/preferences.dart';
import 'package:loja_virtual/widgets/info_card.dart';
import 'package:url_launcher/url_launcher.dart';

class MyOrdersController extends GetxController {
  RxList<Order> orders = <Order>[].obs;

  MyOrdersController() {
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    Firestore db = Firestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await auth.currentUser();

    if (firebaseUser != null) {
      db
          .collection('orders')
          .where('idUsuario', isEqualTo: firebaseUser.uid)
          .snapshots()
          .listen((querySnapshot) {
        orders.value =
            querySnapshot.documents.map((e) => Order.fromDocument(e)).toList();

        orders.sort((Order a, Order b) => b.orderId.compareTo(a.orderId));
      });
    }
  }

  Future<void> senMessageInWhatsApp(int orderId) async {
    UserManager userManager = Get.find();
    String userName = userManager.userNormal.name;
    String mensagem;
    DateTime data = DateTime.now();

    if (data.hour >= 0 && data.hour <= 11) {
      mensagem = 'Bom%20dia,%20';
    } else if (data.hour >= 12 && data.hour <= 17) {
      mensagem = 'Boa%20tarde,%20';
    } else {
      mensagem = 'Boa%20noite,%20';
    }
    mensagem += 'me%20chamo%20$userName%20';
    mensagem += 'do%20pedido%20número%20$orderId%20e%20';
    mensagem += 'gostaria%20de%20tirar%20uma%20dúvida';
    String telefoneBoutique = '5514988102858';

    String urlWhats =
        'https://api.whatsapp.com/send?phone=$telefoneBoutique&text=$mensagem';
    await launch(urlWhats);
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
