import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loja_virtual/models/credit_card.dart';
import 'package:loja_virtual/services/cielo_payment.dart';

class CreditCardController extends GetxController{
  
  RxBool _showCancelButton = false.obs;

  bool get showCancelButton => _showCancelButton.value;

  set showCancelButton(bool value)=> _showCancelButton.value = value; 
  
  CieloPayment cieloPayment = new CieloPayment();
  FirebaseAuth auth = FirebaseAuth.instance;
  Firestore db = Firestore.instance;

  Future<void> checkout(CreditCard creditCard) async {
    
    try {
      String payId = await cieloPayment.authorize(
          creditCard: creditCard, orderId: '1', price: 1);

      debugPrint('success $payId');
    } catch (error) {
      Get.rawSnackbar(
          title: 'Ops', message: error, backgroundColor: Colors.red);
      return;
    }

    try {
      await cieloPayment.capture();

      FirebaseUser fUser = await auth.currentUser();

      await db
          .collection('users')
          .document(fUser.uid)
          .updateData({'payId': cieloPayment.payId});

      DocumentSnapshot doc =
          await db.collection('users').document(fUser.uid).get();

      print('suuuucceeeeesssooooooooo ' + doc.data['payId']);
      Get.rawSnackbar(
          title: 'Sucesso',
          message:
              "Compra realizada com sucesso (pay id: ${cieloPayment.payId})",
          backgroundColor: Colors.green);

          showCancelButton = true;
    } catch (error) {
      Get.rawSnackbar(
          title: 'Ops',
          message: 'Deu erro na captura',
          backgroundColor: Colors.red);
      return;
    }
  }

  Future<void> cancelPay() async {
    try {
      await cieloPayment.cancel();

      Get.rawSnackbar(
          title: 'Sucesso',
          message: "Compra cancelada com sucesso",
          backgroundColor: Colors.green);
    } catch (error) {
      Get.rawSnackbar(
          title: 'Ops',
          message: 'Deu erro no cancelamento',
          backgroundColor: Colors.red);
      return;
    }
  }
}