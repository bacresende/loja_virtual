import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:loja_virtual/models/adicional_product.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/screens/base/base_screen.dart';

class CartProduct extends ChangeNotifier {
  String id;
  String price;
  List<AdicionalProduct> adicionalProducts = [];
  Product product;
  int quantity;

  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _db = Firestore.instance;

  CartProduct() {
    product = new Product();
  }

  CartProduct.fromMap(Map<String, dynamic> map){
    this.adicionalProducts = (map['adicionais'] as List<dynamic> ?? []).map((e) => AdicionalProduct.fromMap2(e)).toList();
    this.price = map['price'];
    this.product = Product.fromMap(map['product']);
    this.quantity = map['quantityItem'];

  }

  CartProduct.fromDocument(DocumentSnapshot document) {
    this.id = document.documentID;
    this.price = document.data['price'] as String;
    this.product = Product.fromMap(document.data['product']);
    this.quantity = document.data['quantityItem'] as int;
    this.adicionalProducts =
        (document.data['adicionais'] as List<dynamic> ?? [])
            .map((e) => AdicionalProduct.fromMap2(e as Map<String, dynamic>))
            .toList();

    /*db.document('products/$productId').get().then(
        (DocumentSnapshot doc) => this.product = Product.fromDocument(doc));*/
  }

  Future<void> save() async {
    try {
      FirebaseUser user = await _auth.currentUser();

      await _db
          .collection('users')
          .document(user.uid)
          .collection('cart')
          .add(toMap());
      
    } catch (e) {
      print(e.code);
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'price': this.price,
      'quantityItem': this.quantity,
      'product': product.toMap2(),
      'adicionais': adicionalProducts.map((e) => e.toMap2()).toList()
    };
    return map;
  }

  Map<String, dynamic> toMapDetail() {
    Map<String, dynamic> map = {
      'price': this.price,
      'quantityItem': this.quantity,
      'product': product.toMap2(),
      'adicionais': adicionalProducts.map((e) => e.toMap2()).toList()
    };
    return map;
  }

  @override
  String toString() {
    return 'price $price, adicionalProducts $adicionalProducts, product $product id: $id, quantity: $quantity';
  }
}
