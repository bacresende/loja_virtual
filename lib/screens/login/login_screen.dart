import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loja_virtual/models/address_manager.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/preferences.dart';
import 'package:loja_virtual/screens/signup/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  final UserManager userManager = Get.put(UserManager());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final bool loadingToHome;

  //final UserManager userManager = Get.put(UserManager());

  LoginScreen({this.loadingToHome = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entrar'),
        centerTitle: true,
      ),
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                    key: formKey,
                    child: Obx(() => ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.all(16),
                          children: [
                            TextFormField(
                              controller: emailController,
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
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            TextFormField(
                              controller: passController,
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
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: FlatButton(
                                padding: EdgeInsets.zero,
                                child: Text('Esqueci minha senha'),
                                onPressed: userManager.loading ? null : () {},
                              ),
                            ),
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
                                          valueColor: AlwaysStoppedAnimation(
                                              Colors.white),
                                        )
                                      : Text(
                                          'Entrar',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                  onPressed: userManager.loading
                                      ? null
                                      : () {
                                          if (formKey.currentState.validate()) {
                                            User user = User(
                                                email: emailController.text,
                                                password: passController.text);

                                            userManager.signIn(
                                              user: user,
                                            );
                                          }
                                        }),
                            )
                          ],
                        )),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                FlatButton(
                  textColor: corRosa,
                  child: Text('Não tem conta? Clique Aqui'),
                  onPressed: () {
                    Get.to(SignupScreen());
                  },
                ),
                loadingToHome
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(corRosa),
                      )
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
