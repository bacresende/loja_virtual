import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loja_virtual/helpers/firebase_erros.dart';
import 'package:loja_virtual/models/address_manager.dart';
import 'package:loja_virtual/models/card_fidelity_manager.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/page_manager.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/screens/base/base_screen.dart';
import 'package:loja_virtual/screens/login/login_screen.dart';
import 'package:loja_virtual/screens/payment_info/payment_info_screen.dart';

class UserManager extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  Firestore db = Firestore.instance;
  RxBool _loading = false.obs;
  Rx<User> user = User().obs;
  User userNormal = User();
  FirebaseUser currentUser;
  UserManager() {
    _loadCurrentUser();
  }

  bool get isLoggedIn => this.user.value != null;

  Future<void> _loadCurrentUser({FirebaseUser firebaseUser}) async {
    currentUser = firebaseUser ?? await auth.currentUser();
    user.value = null;
    userNormal = null;

    DocumentSnapshot documentSnapshot =
        await db.collection('aux').document('status_app').get();

    bool isPago = documentSnapshot.data['pago'];

    if (isPago) {
      print('entrou no isPago');
      if (currentUser != null) {
        print('entrou no salvamento de instancias ');
        print(currentUser.uid);
        //Get.lazyPut(() => CartManager(currentUser), );
        //Get.lazyPut(() => AddressManager());
        //Get.lazyPut(() => CartManager(currentUser));

        final DocumentSnapshot documentSnapshot =
            await db.collection('users').document(currentUser.uid).get();
        if (documentSnapshot.exists) {
          user.value = User.fromMap(documentSnapshot.data);
          userNormal =
              Get.put(User.fromMap(documentSnapshot.data), permanent: true);
          //GetStorage().write('usuario', 'userNormal');
          await userNormal.saveToken();

          
          Get.offAll(BaseScreen(userNormal));
        }
      }
    } else {
      Get.offAll(PaymentInfoScreen());
    }
  }

  bool get loading => _loading.value;
  set loading(bool value) => _loading.value = value;

  Future<void> signIn({User user}) async {
    loading = true;
    try {
      AuthResult authResult = await auth.signInWithEmailAndPassword(
          email: user.email, password: user.password);
      await _loadCurrentUser(firebaseUser: authResult.user);
    } on PlatformException catch (error) {
      String mensagem = getErrorString(error.code);
      Get.rawSnackbar(
          title: 'Erro', message: mensagem, backgroundColor: Colors.red);
    }
    loading = false;
  }

  Future<void> signUp({User user}) async {
    loading = true;

    try {
      AuthResult authResult = await auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);

      user.id = authResult.user.uid;
      this.user.value = user;
      userNormal = user;
      //Get.put(AddressManager());
      await user.saveData();

      _loadCurrentUser(firebaseUser: authResult.user);
    } on PlatformException catch (error) {
      String mensagem = getErrorString(error.code);
      Get.rawSnackbar(
          title: 'Erro', message: mensagem, backgroundColor: Colors.red);
    }
    loading = false;
  }

  Future<void> signOut() async {
    await auth.signOut();
    this.user.value = null;
    userNormal = null;
    currentUser = null;
    Get.offAll(LoginScreen());
  }
}
