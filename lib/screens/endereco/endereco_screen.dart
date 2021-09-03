import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loja_virtual/preferences.dart';
import 'package:loja_virtual/screens/cart/cart_screen.dart';
import 'package:loja_virtual/screens/endereco/endereco_controller.dart';
import 'package:loja_virtual/widgets/elegant_textfield.dart';

class EnderecoScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final EnderecoController controller = new EnderecoController();

  final bool verifyAddress;
  EnderecoScreen({this.verifyAddress = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Endereço'),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElegantTextFormField(
                        onChange: (String valor) {
                          controller.nomeEndereco = valor;
                          
                        },
                        label: 'Nome do Endereço (Ex Minha Casa)',
                        prefix: controller.saving ? CircularProgressIndicator() : null,
                        keyboardType: TextInputType.text,
                        validator: (String valor) {
                          if (valor.isEmpty) {
                            return 'Não deixe o campo em branco';
                          }
                          return null;
                        },
                      ),
                  Obx(() => ElegantTextFormField(
                        readyOnly: controller.saving,
                        onChange: (String valor) {
                          if (valor.length == 8) {
                            controller.setCep(valor);
                          }
                        },
                        label: 'Digite o CEP',
                        prefix: controller.saving ? CircularProgressIndicator() : null,
                        keyboardType: TextInputType.number,
                        validator: (String valor) {
                          if (valor.isEmpty) {
                            return 'Não deixe o campo em branco';
                          }
                          return null;
                        },
                      )),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5, top: 5),
                    child: TextFormField(
                      controller: controller.enderecoController,
                      cursorColor: corRosa,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: corRosa,
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          labelText: 'Endereço',
                          filled: false,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                      validator: (String valor) {
                        if (valor.isEmpty) {
                          return 'Não deixe o campo em branco';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: ElegantTextFormField(
                      readyOnly: controller.saving,
                      onChange: (String valor) {
                        controller.numeroResidencia = valor;
                      },
                      
                      label: 'Número da Residência',
                      keyboardType: TextInputType.number,
                      validator: (String valor) {
                        if (valor.isEmpty) {
                          return 'Não deixe o campo em branco';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5, top: 5),
                    child: TextFormField(
                      controller: controller.complementoController,
                      cursorColor: corRosa,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: corRosa,
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          labelText: 'Complemento ',
                          filled: false,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                      
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5, top: 5),
                    child: TextFormField(
                      controller: controller.bairroController,
                      cursorColor: corRosa,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: corRosa,
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          labelText: 'Bairro',
                          filled: false,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                      validator: (String valor) {
                        if (valor.isEmpty) {
                          return 'Não deixe o campo em branco';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5, top: 5),
                    child: TextFormField(
                      controller: controller.cidadeController,
                      cursorColor: corRosa,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: corRosa,
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          labelText: 'Cidade',
                          filled: false,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                      validator: (String valor) {
                        if (valor.isEmpty) {
                          return 'Não deixe o campo em branco';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5, top: 5),
                    child: TextFormField(
                      controller: controller.estadoController,
                      cursorColor: corRosa,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: corRosa,
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          labelText: 'Estado',
                          filled: false,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                      validator: (String valor) {
                        if (valor.isEmpty) {
                          return 'Não deixe o campo em branco';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextFormField(
                      onChanged: (String valor){
                        controller.pontoDeReferencia = valor;
                      },
                      cursorColor: corRosa,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: corRosa,
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          labelText: 'Ponto de Referência',
                          filled: false,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                      
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextFormField(
                      onChanged: (String valor){
                        controller.telefone = valor;
                      },
                      cursorColor: corRosa,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        color: corRosa,
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          labelText: 'Telefone',
                          filled: false,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                      validator: (String valor) {
                        if (valor.isEmpty) {
                          return 'Não deixe o campo em branco';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
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
                ? () async {
                    if (formKey.currentState.validate()) {
                      await controller.save();
                      
                      if(verifyAddress){
                        Get.off(CartScreen());
                      }else{
                        Get.back();
                      }
                      
                    }
                  }
                : () {},
          )),
    );
  }
}
