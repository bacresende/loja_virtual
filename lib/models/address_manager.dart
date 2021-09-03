import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:loja_virtual/models/address.dart';

class AddressManager extends GetxController {
  RxList<Address> enderecos = <Address>[].obs;
  Firestore _db = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  AddressManager() {
    _loadAddress();
  }

  Future<void> _loadAddress() async {
    FirebaseUser firebaseUser = await _auth.currentUser();
    if (firebaseUser != null) {
      _db
          .collection('users')
          .document(firebaseUser.uid)
          .collection('address')
          .snapshots()
          .listen((QuerySnapshot snapshot) {
        this.enderecos.value =
            snapshot.documents.map((e) => Address.fromDocument(e)).toList();
      });
    }
  }
}
