import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/preferences.dart';

class CepService {
  static String token = 'a88065a531ca7840fe22fa411ac6a565';

  static Future<Address> getAddressFromCep(String cep) async {
    try {
      String url = "https://www.cepaberto.com/api/v3/cep?cep=$cep";

      http.Response response = await http.get(url, headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Token token=$token"
      });
      print('response');
      print(response.body);
      var map = json.decode(response.body) as Map<String, dynamic>;
      print(map['cidade']['nome']);
      Address address;
      if (map.isNotEmpty) {
        address = new Address.fromMap(map);
      }

      return address;
    } catch (e) {
      Get.rawSnackbar(
          message: "Houve um erro interno, tente novamente",
          backgroundColor: corVermelha);
      return null;
    }
  }
}
