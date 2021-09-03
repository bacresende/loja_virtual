import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:loja_virtual/models/user.dart';

class CardFidelityController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;

  RxString _nomeUser = ''.obs;

  String get nomeUser => _nomeUser.value;

  set nomeUser(String value) => _nomeUser.value = value;

  RxList<double> items = <double>[].obs;

  String get qtdeItems {
    String qtde = '';
    if (items.length > 1) {
      qtde = '${items.length} Pontos';
    } else {
      qtde = '${items.length} Ponto';
    }
    return qtde;
  }

  RxDouble _valorTotal = 0.0.obs;

  double get valorTotal => _valorTotal.value;

  set valorTotal(double value) => _valorTotal.value = value;

  CardFidelityController(User user) {
   
    _loadCard(user);
  }

  Future<void> _loadCard(User user) async {
    FirebaseUser firebaseUser = await auth.currentUser();

    if (firebaseUser != null) {
      Firestore db = Firestore.instance;

      db
          .collection('users')
          .document(firebaseUser.uid)
          .collection('cardFidelity')
          .snapshots()
          .listen((QuerySnapshot querySnapshot) {
        for (DocumentSnapshot documentSnapshot in querySnapshot.documents) {
          String value = documentSnapshot.data['value'];

          double valueDouble = double.parse(value);

          items.add(valueDouble);
          valorTotal += valueDouble;
        }

        nomeUser = user.name;
      });
    }
  }
}
