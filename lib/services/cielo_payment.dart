import 'dart:collection';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/credit_card.dart';
import 'package:loja_virtual/models/user.dart';

class CieloPayment {
  CloudFunctions functions = CloudFunctions.instance;
  String payId = '';

  Future<String> authorize(
      {CreditCard creditCard, num price, String orderId, User user}) async {
    String cpf = creditCard.cpf.replaceAll('.', '').replaceAll('-', '');

    try {
      Map<String, dynamic> dataSale = {
        'merchantOrderId': orderId,
        'amount': (price * 100).toInt(),
        'softDescriptor': 'Mobiance',
        'installments': 1,
        'creditCard': creditCard.toMap(),
        'cpf': cpf,
        'paymentType': 'CreditCard'
      };

      HttpsCallable httpsCallable =
          functions.getHttpsCallable(functionName: 'authorizeCreditCard');

      httpsCallable.timeout = Duration(seconds: 60);
      HttpsCallableResult result = await httpsCallable.call(dataSale);

      Map<String, dynamic> data =
          Map<String, dynamic>.from(result.data as LinkedHashMap);

      if (data['success'] as bool) {
        this.payId = data['paymentId'];
        return data['paymentId'] as String;
      } else {
        String message = data['error']['message'];

        return Future.error(message);
      }
    } catch (e) {
      return Future.error('Verifique a sua conexão com a internet');
    }
  }

  Future<void> capture() async {
    Map<String, dynamic> capturaData = {
      'payId': this.payId,
    };

    HttpsCallable httpsCallable =
        functions.getHttpsCallable(functionName: 'captureCreditCard');

    httpsCallable.timeout = Duration(seconds: 60);
    HttpsCallableResult result = await httpsCallable.call(capturaData);

    Map<String, dynamic> data =
        Map<String, dynamic>.from(result.data as LinkedHashMap);

    if (data['success'] as bool) {
      debugPrint('Captura realizada com sucesso');
    } else {
      return Future.error(data['error']['message']);
    }
  }

  Future<void> cancel() async {
    HttpsCallable httpsCallable =
        functions.getHttpsCallable(functionName: 'cancelCreditCard');

    httpsCallable.timeout = Duration(seconds: 60);
    HttpsCallableResult result = await httpsCallable.call();

    Map<String, dynamic> data =
        Map<String, dynamic>.from(result.data as LinkedHashMap);
    print(data);
    if (data['success'] as bool) {
      debugPrint('Cancelamento realizado com sucesso');
    } else {
      return Future.error(data['error']['message']);
    }
  }
}
