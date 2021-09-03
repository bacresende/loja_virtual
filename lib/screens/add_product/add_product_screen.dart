import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:loja_virtual/models/adicional_product.dart';
import 'package:loja_virtual/preferences.dart';
import 'package:loja_virtual/screens/add_product/add_product_controller.dart';
import 'package:loja_virtual/screens/add_product/widgets/lista_fotos.dart';
import 'package:loja_virtual/widgets/text_info.dart';
import 'package:loja_virtual/widgets/elegant_textfield.dart';

class AddProductScreen extends StatelessWidget {
  final String diaDaSemana;
  final formKey = GlobalKey<FormState>();
  final AddProductController controller = new AddProductController();
  AddProductScreen({@required this.diaDaSemana});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produto de $diaDaSemana'),
      ),
      body: Container(
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                ListFotos(controller),
                ElegantTextFormField(
                  onChange: (String valor) {
                    controller.product.name = valor;
                  },
                  label: 'Digite o nome do Produto',
                  keyboardType: TextInputType.text,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  validator: (String valor) {
                    if (valor.isEmpty) {
                      return 'Não deixe o campo em branco';
                    }
                    return null;
                  },
                ),
                ElegantTextFormField(
                  onChange: (String valor) {
                    controller.product.description = valor;
                  },
                  label: 'Digite uma descrição do Produto',
                  keyboardType: TextInputType.text,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  validator: (String valor) {
                    if (valor.isEmpty) {
                      return 'Não deixe o campo em branco';
                    }
                    return null;
                  },
                ),
                ElegantTextFormField(
                  onChange: (String valor) {
                    valor = valor.replaceAll('.', '');
                    valor = valor.replaceAll(',', '.');
                    controller.product.price = valor;
                  },
                  label: 'Digite o preço do Produto',
                  keyboardType: TextInputType.number,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  validator: (String valor) {
                    if (valor.isEmpty) {
                      return 'Não deixe o campo em branco';
                    }
                    return null;
                  },
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    RealInputFormatter(centavos: true),
                  ],
                ),
                Divider(
                  thickness: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => controller.itens.length > 0
                        ? TextInfo(
                            'Adiciona${controller.itens.length == 1 ? 'l' : 'is'} ${controller.itens.length} ')
                        : Container()),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            color: Colors.pink,
                            child: Text(
                              'Inserir Adicionais',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              controller.openDialogAdd();
                            }),
                      ),
                    ),
                  ],
                ),
                Obx(() => controller.itens.length > 0
                    ? Expanded(
                        child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          child: ListView.separated(
                              separatorBuilder: (_, index) => Divider(),
                              itemCount: controller.itens.length,
                              itemBuilder: (_, index) {
                                AdicionalProduct adicionalProduct =
                                    controller.itens[index];
                                return ListTile(
                                  title: Text(
                                    'item: ${adicionalProduct.name}',
                                    style: TextStyle(
                                        color: Colors.pink,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20),
                                  ),
                                  subtitle: Text(
                                    'valor: R\$ ${adicionalProduct.price}',
                                    style: TextStyle(
                                      color: Colors.pink,
                                    ),
                                  ),
                                  onTap: () {
                                    controller.deleteItens(
                                        adicionalProduct, index);
                                  },
                                );
                              }),
                        ),
                      ))
                    : Container()),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Obx(() => GestureDetector(
            child: Container(
              color: !controller.loading ? corRosa : Colors.black,
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    !controller.loading ? 'Salvar' : 'Salvando...',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            onTap: !controller.loading
                ? () {
                    if (formKey.currentState.validate()) {
                      controller.save(diaDaSemana);
                    }
                  }
                : () {},
          )),
    );
  }
}
