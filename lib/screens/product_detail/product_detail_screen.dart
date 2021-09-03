import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loja_virtual/helpers/moeda_util.dart';
import 'package:loja_virtual/models/adicional_product.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/preferences.dart';
import 'package:loja_virtual/screens/base/base_screen.dart';
import 'package:loja_virtual/screens/home/home_screen.dart';
import 'package:loja_virtual/widgets/text_info.dart';
import 'package:loja_virtual/screens/product_detail/product_detail_controller.dart';
import 'package:loja_virtual/screens/ver_imagem_completa/ver_imagem_completa_screen.dart';
import 'package:loja_virtual/widgets/info_card.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  ProductDetailScreen(this.product);


  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  ProductDetailController controller = new ProductDetailController();
  String valorTemporario = '';
  Product product;
  @override
  void initState() {
    super.initState();
    product = widget.product.clone();
    controller.valorFixo = product.price;
    controller.valorTotal = product.price;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(product.name),
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              product.images.isNotEmpty
                  ? SizedBox(
                      height: 250,
                      child: Carousel(
                        images:
                            controller.getListaImagens(product.images),
                        autoplay: false,
                        dotSize: 8,
                        dotBgColor: Colors.transparent,
                        dotIncreasedColor: corRosa,
                        onImageTap: (int index) {
                          String foto = product.images[index];
                          Get.to(VerImagemCompleta(foto));
                        },
                      ),
                    )
                  : Container(),
              InfoCard(
                  text: product.description,
                  info: 'Descrição',
                  icon: Icons.short_text),
              Divider(),
              product.adicionais.length > 0
                  ? TextInfo(
                      'Adiciona${product.adicionais.length > 1 ? 'is' : 'l'} ')
                  : Container(),
              Expanded(
                child: ListView.builder(
                    itemCount: product.adicionais.length,
                    itemBuilder: (_, index) {
                      AdicionalProduct addProduct =
                          product.adicionais[index];

                      return ListTile(
                        title: Text(
                          addProduct.name,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text('R\$ ${addProduct.price}',
                            style:
                                TextStyle(fontSize: 16, color: Colors.green)),
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
                                onPressed: addProduct.quantity == 0
                                    ? null
                                    : () {
                                        if (addProduct.quantity > 0) {
                                          controller.decrementItem(addProduct);
                                          setState(() {});
                                        }
                                      }),
                            Text(
                              '${addProduct.quantity}',
                              style: TextStyle(fontSize: 20),
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.add,
                                  size: 30,
                                ),
                                color: corRosa,
                                onPressed: () {
                                  controller.incrementItem(addProduct);
                                  setState(() {});
                                })
                          ],
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
        bottomNavigationBar: Obx(() => GestureDetector(
              child: Container(
                color: !controller.loading ? Colors.green : Colors.black,
                padding: EdgeInsets.all(15),
                child: !controller.loading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Confirmar',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'R\$ ' +
                                MoedaUtil.formatarValor(controller.valorTotal),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Salvando',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
              ),
              onTap: !controller.loading ? () async {
                
                controller.showModalBottom(product);
              } : (){},
            )));
  }
}
