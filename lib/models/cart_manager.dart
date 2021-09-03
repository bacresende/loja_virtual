import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:loja_virtual/models/cart_product.dart';
import 'package:loja_virtual/models/user.dart';

class CartManager extends GetxController {
  RxList<CartProduct> items = <CartProduct>[].obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  Firestore db = Firestore.instance;
  //User user;
  FirebaseUser firebaseUser;
  QuerySnapshot cartSnap;
  User user = new User();

  CartManager(FirebaseUser firebaseUser, {String id}){
    if(firebaseUser == null){
      onInit2(id);

    }else{
      onInit(userFirebase: firebaseUser);
    }
    
  }

  void onInit({FirebaseUser userFirebase}) async {

    firebaseUser = userFirebase ?? await auth.currentUser();

    if (this.firebaseUser != null) {
      print('verificar carrinho');
      await verifyCart();
    }
  }

  void onInit2(String id) async {
    
      await verifyCart2(id);
    
  }

  Future<void> verifyCart2(String id) async {
    db
        .collection('users')
        .document(id)
        .collection('cart')
        .snapshots()
        .listen((event) async {
      this.cartSnap = event;

      if (this.cartSnap.documents.length > 0) {
        await setCart();
      }
    });

    //this.cartSnap = await this.user.cartRefence.getDocuments();
  }

  Future<void> verifyCart() async {
    db
        .collection('users')
        .document(this.firebaseUser.uid)
        .collection('cart')
        .snapshots()
        .listen((event) async {
      this.cartSnap = event;

      if (this.cartSnap.documents.length > 0) {
        await setCart();
      }
    });

    //this.cartSnap = await this.user.cartRefence.getDocuments();
  }

  Future<void> setCart() async {

    await _loadCartItems();
  }

  Future<void> _loadCartItems() async {

    this.items.value = cartSnap.documents
        .map((DocumentSnapshot doc) => CartProduct.fromDocument(doc))
        .toList();
    //this.items.addAll(listaLocal);
  }

  void deletItemToCart(CartProduct cartProduct) {
    items.removeWhere((CartProduct p) => p.id == cartProduct.id);
    user.cartRefence.document(cartProduct.id).delete();
  }
}
