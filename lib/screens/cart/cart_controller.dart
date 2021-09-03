import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loja_virtual/helpers/delivery.dart';
import 'package:loja_virtual/helpers/moeda_util.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/address_manager.dart';
import 'package:loja_virtual/models/card_fidelity_manager.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/cart_product.dart';
import 'package:loja_virtual/models/order.dart';
import 'package:loja_virtual/models/page_manager.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/preferences.dart';
import 'package:loja_virtual/screens/base/base_screen.dart';
import 'package:loja_virtual/screens/cart/widgets/list_tile_resume.dart';
import 'package:loja_virtual/screens/endereco/endereco_screen.dart';
import 'package:loja_virtual/screens/login/login_screen.dart';
import 'package:loja_virtual/widgets/elegant_dialog.dart';
import 'package:loja_virtual/widgets/info_card.dart';

class CartController extends GetxController {
  final CartManager cartManager = Get.find();
  final UserManager userManager = Get.find();
  AddressManager addressManager = Get.find();
  CardFidelityManager cardFidelityManager = Get.find();
  Firestore _db = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  double taxaDeEntrega;
  double valorDesconto = 0;

  RxBool _loading = false.obs;

  bool get loading => _loading.value;

  set loading(bool value) => _loading.value = value;

  RxString _pagamentoSelecionado = 'Dinheiro'.obs;

  String get pagamentoSelecionado => _pagamentoSelecionado.value;

  set pagamentoSelecionado(String value) => _pagamentoSelecionado.value = value;

  RxString _valor = ''.obs;

  String get valor {
    double preco = 0;

    for (CartProduct cartProduct in cartManager.items) {
      preco += double.parse(cartProduct.price);
    }
    valor = preco.toStringAsFixed(2);
    return _valor.value;
  }

  set valor(String value) => _valor.value = value;

  dialogDeleteCart() {
    showDialog(
        context: Get.context,
        builder: (context) {
          return ElegantDialog(
            titulo: 'Deletar Carrinho',
            descricao: 'Tem certeza que deseja deletar todo o carrinho?',
            primeiroBotao: FlatButton(
              child: Text(
                'Não',
                style: TextStyle(color: Colors.green, fontSize: 22),
              ),
              onPressed: () {
                Get.back();
              },
            ),
            segundoBotao: FlatButton(
              child: Text('Sim',
                  style: TextStyle(
                      color: corRosa,
                      fontSize: 22,
                      fontWeight: FontWeight.w600)),
              onPressed: () async {
                await deleteCart();
              },
            ),
            icone: Icons.remove_shopping_cart_outlined,
          );
        });
  }

  Future<void> deleteCart() async {
    FirebaseUser firebaseUser = await _auth.currentUser();
    List<CartProduct> cartProducts = cartManager.items;
    for (CartProduct cartProduct in cartProducts) {
      _db
          .collection('users')
          .document(firebaseUser.uid)
          .collection('cart')
          .document(cartProduct.id)
          .delete();
    }

    cartManager.items.clear();
    Get.delete<CartManager>();
    Get.lazyPut(() => CartManager(firebaseUser));

    Get.offAll(LoginScreen(
      loadingToHome: true,
    ));
  }

  void dialogDeleteItemCart(CartProduct cartProduct) {
    showDialog(
        context: Get.context,
        builder: (context) {
          return ElegantDialog(
            titulo: 'Deletar Item',
            descricao:
                'Tem certeza que deseja deletar ${cartProduct.product.name}?',
            primeiroBotao: FlatButton(
              child: Text(
                'Não',
                style: TextStyle(color: Colors.green, fontSize: 22),
              ),
              onPressed: () {
                Get.back();
              },
            ),
            segundoBotao: FlatButton(
              child: Text('Sim',
                  style: TextStyle(
                      color: corRosa,
                      fontSize: 22,
                      fontWeight: FontWeight.w600)),
              onPressed: () async {
                if (cartManager.items.length == 1) {
                  await deleteCart();
                } else {
                  await deleteItemCart(cartProduct);
                  Get.back();
                }
              },
            ),
            icone: Icons.remove_shopping_cart_outlined,
          );
        });
  }

  Future<void> deleteItemCart(CartProduct cartProduct) async {
    FirebaseUser firebaseUser = await _auth.currentUser();
    await _db
        .collection('users')
        .document(firebaseUser.uid)
        .collection('cart')
        .document(cartProduct.id)
        .delete();
  }

  Future<void> openModalEnderecos() async {
    showModalBottomSheet(
        isScrollControlled: true,
        context: Get.context,
        builder: (context) {
          if (addressManager.enderecos.length > 0) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(
                    color: corRosa,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Selecione o endereço para a entrega',
                        style: flatButtonBrancoStyle,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      children: addressManager.enderecos
                          .map((Address address) => Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    child: ListTile(
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${address.nomeEndereco}',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: corRosa,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            '${address.endereco} - ${address.estado}',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                      subtitle: Text(
                                          'Telefone: ${address.telefone}',
                                          style: TextStyle(fontSize: 16)),
                                      leading: Icon(
                                        Icons.pin_drop_outlined,
                                        color: corRosa,
                                      ),
                                      onTap: () async {
                                        taxaDeEntrega =
                                            await Delivery.calculateDelivery(
                                                address.latitude,
                                                address.longitude);
                                        openModalMethodPayment(address);
                                      },
                                    ),
                                  ),
                                  Divider()
                                ],
                              ))
                          .toList(),
                    ),
                  )
                ],
              ),
            );
          } else {
            return Container(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 35.0),
                    child: Text(
                      'Você ainda não tem endereços cadastros',
                      style: flatButtonRosaStyle,
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      color: corRosa,
                      padding: EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Criar Endereço',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    onTap: () async {
                      Get.to(EnderecoScreen(
                        verifyAddress: true,
                      ));
                    },
                  ),
                ],
              ),
            );
          }
        });
  }

  Future<void> openModalMethodPayment(Address address) async {
    showModalBottomSheet(
        isScrollControlled: true,
        context: Get.context,
        builder: (context) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Card(
                    color: corRosa,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Selecione o método de pagamento',
                        style: flatButtonBrancoStyle,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Obx(() => Column(
                        children: [
                          RadioListTile(
                              title: Text(
                                'Dinheiro',
                                style: flatButtonPretoStyle,
                              ),
                              activeColor: corRosa,
                              value: 'Dinheiro',
                              groupValue: pagamentoSelecionado,
                              onChanged: (String valor) {
                                pagamentoSelecionado = valor;
                              }),
                          RadioListTile(
                              title: Text(
                                'Pix',
                                style: flatButtonPretoStyle,
                              ),
                              activeColor: corRosa,
                              value: 'Pix',
                              groupValue: pagamentoSelecionado,
                              onChanged: (String valor) {
                                pagamentoSelecionado = valor;
                              }),
                          Obx(() => pagamentoSelecionado == 'Pix'
                              ? Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      child: InfoCard(
                                        text: '408.564.258-85',
                                        info:
                                            'Faça o Pagamento por essa chave PIX: \n',
                                        icon: Icons.monetization_on,
                                        color: corRosa,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ))
                              : Container()),
                          RadioListTile(
                              title: Text(
                                'Cartão de Crédito',
                                style: flatButtonPretoStyle,
                              ),
                              subtitle: Text('Acréscimo de 6%',
                                  style: TextStyle(color: corRosa)),
                              activeColor: corRosa,
                              value: 'Cartão de Crédito',
                              groupValue: pagamentoSelecionado,
                              onChanged: (String valor) {
                                pagamentoSelecionado = valor;
                              }),
                          RadioListTile(
                              title: Text(
                                'Cartão de Débito',
                                style: flatButtonPretoStyle,
                              ),
                              subtitle: Text('Acréscimo de R\$ 1',
                                  style: TextStyle(color: corRosa)),
                              activeColor: corRosa,
                              value: 'Cartão de Débito',
                              groupValue: pagamentoSelecionado,
                              onChanged: (String valor) {
                                pagamentoSelecionado = valor;
                              }),
                        ],
                      )),
                ),
                GestureDetector(
                  child: Container(
                    color: corRosa,
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Finalizar Pedido',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    openModalResumePay(address);
                  },
                ),
              ],
            ),
          );
        });
  }

  Future<void> openModalResumePay(Address address) async {
    verifyTotalPointsCupom();

    showModalBottomSheet(
        isScrollControlled: true,
        context: Get.context,
        builder: (context) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Card(
                    color: corRosa,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Resumo do Seu Pedido',
                            style: flatButtonBrancoStyle,
                          ),
                          CircleAvatar(
                            backgroundColor: corBranca,
                            child: IconButton(
                                icon: Icon(
                                  Icons.check,
                                  color: corRosa,
                                ),
                                onPressed: () async {
                                  await save(address);
                                }),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: InfoCard(
                              text: pagamentoSelecionado,
                              info: 'Forma de Pagamento',
                              icon: Icons.monetization_on,
                              color: corRosa,
                              fontSize: 18,
                            ),
                          )),
                      Divider(),
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        margin: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Column(
                                children: cartManager.items
                                    .map((CartProduct cartProduct) =>
                                        ListTileResume(cartProduct))
                                    .toList(),
                              ),
                              Divider(),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Sub total',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'R\$ ${MoedaUtil.formatarValor(valor)}',
                                      style: flatMiniButtonPretoStyle,
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Taxa de Entrega',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'R\$ ${MoedaUtil.formatarValor('$taxaDeEntrega')}',
                                      style: flatMiniButtonPretoStyle,
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Taxa de $pagamentoSelecionado',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'R\$ ${MoedaUtil.formatarValor('${getTaxaAcrescimo()}')}',
                                      style: flatMiniButtonPretoStyle,
                                    )
                                  ],
                                ),
                              ),
                              valorDesconto > 0
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Desconto Aplicado',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.green),
                                          ),
                                          Text(
                                            '- R\$ ${MoedaUtil.formatarValor('$valorDesconto')}',
                                            style: flatMiniButtonVerdeStyle,
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(),
                              Divider(),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total a Pagar',
                                      style: TextStyle(
                                          color: corRosa,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                    ),
                                    Text(
                                      'R\$ ${getTotalPay()}',
                                      style: flatButtonRosaStyle,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                ),
                GestureDetector(
                  child: Container(
                    color: Colors.green,
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Confirmar Pedido',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    await save(address);
                  },
                ),
              ],
            ),
          );
        });
  }

  void verifyTotalPointsCupom() {
    if (cardFidelityManager.items.length >= 10) {
      this.valorDesconto = cardFidelityManager.valorTotal;
    }
  }

  double getTaxaAcrescimo() {
    double acrescimo = 0;
    if (pagamentoSelecionado == 'Cartão de Crédito') {
      acrescimo = double.parse(valor) * 0.06;
    } else if (pagamentoSelecionado == 'Cartão de Débito') {
      acrescimo = 1;
    } else {
      acrescimo = 0;
    }

    return acrescimo;
  }

  String getTotalPay() {
    double total = double.parse(valor) +
        taxaDeEntrega +
        getTaxaAcrescimo() -
        valorDesconto;
    if (total < 0) {
      total = 0;
    }
    String valorTotalFormatado = MoedaUtil.formatarValor('$total');
    return valorTotalFormatado;
  }

  Future<void> save(Address address) async {
    Get.back();
    Get.back();
    Get.back();

    loading = true;

    Order order = new Order();
    order.valorTotal = getTotalPay();
    order.orderId = await getOrderId();
    order.idUsuario = userManager.userNormal.id;
    order.pagamentoSelecionado = pagamentoSelecionado;
    order.address = address;
    order.items = cartManager.items;

    await order.save();

    await deleteCart();

    //Get.offAll(BaseScreen(user));

    if (cardFidelityManager.items.length >= 10) {
      await deleteCardFidelity();
    }

    loading = false;
  }

  Future<void> deleteCardFidelity() async {
    FirebaseUser firebaseUser = await _auth.currentUser();

    QuerySnapshot querySnapshot = await _db
        .collection('users')
        .document(firebaseUser.uid)
        .collection('cardFidelity')
        .getDocuments();

    for (DocumentSnapshot document in querySnapshot.documents) {
      _db
          .collection('users')
          .document(firebaseUser.uid)
          .collection('cardFidelity')
          .document(document.documentID)
          .delete();
    }

    await setDataFidelityUser(firebaseUser.uid);

    //Get.delete<CardFidelityManager>();
  }

  Future<void> setDataFidelityUser(String idUsuario) async {
    await _db
        .collection('users')
        .document(idUsuario)
        .updateData({'data_valid_fidelity': null});
  }

  Future<int> getOrderId() async {
    DocumentReference orderReference =
        _db.collection('aux').document('ordercounter');

    final result = await _db.runTransaction((Transaction tx) async {
      DocumentSnapshot doc = await tx.get(orderReference);
      int orderId = doc.data['current'] as int;

      await tx.update(orderReference, {'current': orderId + 1});

      return {'orderId': orderId};
    });
    return result['orderId'];
  }
}
