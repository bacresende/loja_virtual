import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:loja_virtual/models/user.dart';

class CardFidelityManager extends GetxController {
  Firestore db = Firestore.instance;
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

  CardFidelityManager(User user) {
    
    _loadCard(user);
    _verifyValidateCard(user);
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
        items.clear();
        valorTotal = 0;
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

  Future<void> _verifyValidateCard(User user) async {
    
    DocumentSnapshot documentSnapshot =
        await db.collection('users').document(user.id).get();
    
    if(documentSnapshot.data['data_valid_fidelity'] != null){
      Timestamp timestamp = documentSnapshot.data['data_valid_fidelity'];

      DateTime dataBanco = timestamp.toDate();

      bool equalDate = getDayMonthYear(dataBanco);

      if(equalDate){
        await deleteCardFidelity(user);
      }

    }
    
  }

  bool getDayMonthYear(DateTime dataBanco){
    DateTime dataAtual = DateTime.now();
    String dayMonthYearAtual = '${dataAtual.day}/${dataAtual.month}/${dataAtual.year}';
    String dayMonthYearBanco = '${dataBanco.day}/${dataBanco.month}/${dataBanco.year}';

    return dayMonthYearAtual == dayMonthYearBanco;

  }

  Future<void> deleteCardFidelity(User user) async {

    QuerySnapshot querySnapshot = await db
        .collection('users')
        .document(user.id)
        .collection('cardFidelity')
        .getDocuments();

    for (DocumentSnapshot document in querySnapshot.documents) {
      db
          .collection('users')
          .document(user.id)
          .collection('cardFidelity')
          .document(document.documentID)
          .delete();
    }

    await setDataFidelityUser(user.id);
  }

  Future<void> setDataFidelityUser(String idUsuario) async {
    await db
        .collection('users')
        .document(idUsuario)
        .updateData({'data_valid_fidelity': null});
  }
}
