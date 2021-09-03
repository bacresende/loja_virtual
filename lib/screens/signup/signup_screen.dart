import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/preferences.dart';

class SignupScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final User user = new User();
  final UserManager userManager = Get.find<UserManager>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Conta'),
        centerTitle: true,
      ),
      body: Container(
        child: Center(
          child: Card(
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: formKey,
              child: Obx(() => ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(16),
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Digite seu Nome Completo',
                        ),
                        enabled: !userManager.loading,
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        validator: (String valor) {
                          if (valor.isEmpty) {
                            return 'Não deixe o campo em branco';
                          } else if (valor.length < 3) {
                            return 'Digite um nome válido';
                          }

                          return null;
                        },
                        onSaved: (String valor) => user.name = valor,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Digite seu E-mail',
                          ),
                          enabled: !userManager.loading,
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          validator: (String valor) {
                            if (valor.isEmpty) {
                              return 'Não deixe o campo em branco';
                            } else if (!GetUtils.isEmail(valor)) {
                              return 'Digite um e-mail válido';
                            }

                            return null;
                          },
                          onSaved: (String valor) => user.email = valor),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Digite sua Senha',
                          ),
                          enabled: !userManager.loading,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          autocorrect: false,
                          validator: (String valor) {
                            if (valor.isEmpty) {
                              return 'Não deixe o campo em branco';
                            } else if (valor.length < 6) {
                              return 'Digite uma senha com mais de 6 dígitos';
                            }

                            return null;
                          },
                          onSaved: (String valor) => user.password = valor),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Confirme sua Senha',
                          ),
                          enabled: !userManager.loading,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          autocorrect: false,
                          validator: (String valor) {
                            if (valor.isEmpty) {
                              return 'Não deixe o campo em branco';
                            } else if (valor.length < 6) {
                              return 'Digite uma senha com mais de 6 dígitos';
                            }

                            return null;
                          },
                          onSaved: (String valor) =>
                              user.confirmPassword = valor),
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 44,
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            color: primaryColor,
                            textColor: Colors.white,
                            disabledColor: primaryColor.withAlpha(100),
                            child: userManager.loading
                                ? CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                  )
                                : Text(
                                    'Criar Conta',
                                    style: TextStyle(fontSize: 18),
                                  ),
                            onPressed: userManager.loading
                                ? null
                                : () {
                                    if (formKey.currentState.validate()) {
                                      formKey.currentState.save();

                                      if (user.validatePass) {
                                        userManager.signUp(user: user);
                                      } else {
                                        Get.rawSnackbar(
                                            title: 'Senhas Não coincidem',
                                            message:
                                                'As senhas não devem ser diferentes',
                                            backgroundColor: Colors.red);
                                      }
                                    }
                                  }),
                      )
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
