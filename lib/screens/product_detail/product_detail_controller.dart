import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:loja_virtual/helpers/moeda_util.dart';
import 'package:loja_virtual/models/adicional_product.dart';
import 'package:loja_virtual/models/cart_product.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/preferences.dart';
import 'package:loja_virtual/widgets/info_card.dart';

class ProductDetailController extends GetxController {
  CartProduct cartProduct = new CartProduct();

  RxString _valorFixo = ''.obs;

  String get valorFixo => _valorFixo.value;

  set valorFixo(String value) => _valorFixo.value = value;

  RxString _valorTotal = ''.obs;

  String get valorTotal => _valorTotal.value;

  set valorTotal(String value) => _valorTotal.value = value;

  RxInt _quantity = 1.obs;

  int get quantity => _quantity.value;

  set quantity(int value) => _quantity.value = value;

  bool get hasMinQuantity => quantity == 1;

  RxBool _loading = false.obs;

  bool get loading => _loading.value;

  set loading(bool value)=> _loading.value = value;

  List<Container> getListaImagens(List<String> images) {
    return images
        .map((String url) => Container(
              height: 250,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(url), fit: BoxFit.fitWidth)),
            ))
        .toList();
  }

  void decrementItem(AdicionalProduct addProduct) {
    addProduct.quantity--;
    if (quantity > 1) {
      double valor = double.parse(valorTotal) -
          (quantity * double.parse(addProduct.price));
      valorTotal = valor.toStringAsFixed(2);
      valorFixo = valor.toStringAsFixed(2);
      cartProduct.adicionalProducts.add(addProduct);
    } else {
      double valor = double.parse(valorTotal) - double.parse(addProduct.price);
      valorTotal = valor.toStringAsFixed(2);
      valorFixo = valor.toStringAsFixed(2);
      cartProduct.adicionalProducts.add(addProduct);
    }
  }

  void incrementItem(AdicionalProduct addProduct) {
    addProduct.quantity++;

    double valor =
        double.parse(valorTotal) + (quantity * double.parse(addProduct.price));
    valorTotal = valor.toStringAsFixed(2);
    valorFixo = valor.toStringAsFixed(2);
    cartProduct.adicionalProducts.add(addProduct);
  }

  void decrementQuantity() {
    if (quantity > 1) {
      quantity--;
      double valor = double.parse(valorFixo) * quantity;
      valorTotal = valor.toStringAsFixed(2);
    }
  }

  void incrementQuantity() {
    quantity++;
    double valor = double.parse(valorFixo) * quantity;
    valorTotal = valor.toStringAsFixed(2);
  }

  void showModalBottom(Product product) {
    quantity = 1;
    showModalBottomSheet(
        isScrollControlled: true,
        context: Get.context,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: CircleAvatar(
                            backgroundColor: Colors.green,
                            child: IconButton(
                              icon: Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                await addToCartAndSave(product);
                                if (product.adicionais.isNotEmpty) {
                                  for (AdicionalProduct addProduct
                                      in product.adicionais) {
                                    addProduct.quantity = 0;
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                        Text(
                          'Resumo do pedido',
                          style: flatButtonRosaStyle,
                        ),
                        Divider(),
                        InfoCard(
                            text: product.name,
                            info: 'Nome',
                            icon: Icons.food_bank_outlined),
                        product.adicionais.isNotEmpty
                            ? Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Adicionais',
                                    style: TextStyle(fontSize: 18)))
                            : Container(),
                        Wrap(
                            children: product.adicionais
                                .map((AdicionalProduct adicionalProduct) =>
                                    ListTile(
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(adicionalProduct.name),
                                          Text(
                                              '${adicionalProduct.quantity} Unidade'),
                                        ],
                                      ),
                                    ))
                                .toList()),
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'Qual a quantidade você quer desse pedido?',
                      style: flatButtonRosaStyle,
                    ),
                  ),
                  Obx(() => Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          elevation: 10,
                          child: ListTile(
                            title: Text(
                              'Quantidade',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            trailing: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    icon: Icon(
                                      Icons.remove,
                                      size: 30,
                                    ),
                                    color: corRosa,
                                    onPressed: hasMinQuantity
                                        ? null
                                        : () {
                                            decrementQuantity();
                                          }),
                                Text(
                                  '$quantity',
                                  style: TextStyle(fontSize: 20),
                                ),
                                IconButton(
                                    icon: Icon(
                                      Icons.add,
                                      size: 30,
                                    ),
                                    color: corRosa,
                                    onPressed: () {
                                      incrementQuantity();
                                    })
                              ],
                            ),
                          ),
                        ),
                      )),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      color: corRosa,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Valor Total',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: corBranca,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Obx(() => Text(
                                  'R\$ ' + MoedaUtil.formatarValor(valorTotal),
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: corBranca,
                                      fontWeight: FontWeight.w600),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                  GestureDetector(
                    child: Container(
                      color: Colors.green,
                      padding: EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Add ao Carrinho',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    onTap: () async {
                      loading = true;
                      Get.back();
                      Get.back();
                      await addToCartAndSave(product);
                      if (product.adicionais.isNotEmpty) {
                        for (AdicionalProduct addProduct
                            in product.adicionais) {
                          addProduct.quantity = 0;
                        }
                      }
                      loading = false;
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<void> addToCartAndSave(Product product) async {
    cartProduct.product = product;
    cartProduct.price = valorTotal;
    cartProduct.quantity = quantity;
    cartProduct.adicionalProducts =
        cartProduct.adicionalProducts.toSet().toList();
    await cartProduct.save();

  }
}
