import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class User {
  String email;
  String password;
  String name;
  String confirmPassword;
  bool admin = false;
  String id;
  String token;
  Firestore _db = Firestore.instance;

  User({this.email, this.password, this.name, this.confirmPassword, this.id});

  User.fromMap(Map<String, dynamic> map) {
    this.email = map['email'];
    this.name = map['name'];
    this.id = map['id'];
    this.admin = map['admin'];
  }

  DocumentReference get firestoreRef => _db.document('users/$id');
  CollectionReference get cartRefence => firestoreRef.collection('cart');
  DocumentReference get tokensRef => _db.document('users/$id/tokens/$token');
  bool get validatePass => password == confirmPassword;

  Future<void> saveData() async {
    await firestoreRef.setData(toMap());
  }


  Future<void> updateData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await auth.currentUser();
    this.id = firebaseUser.uid;

    await tokensRef.setData(toMapToken());
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'email': this.email,
      'name': this.name,
      'id': this.id,
      'admin': false
    };

    return map;
  }

  Map<String, dynamic> toMapToken() {
    String plataforma = '';

    bool isAndroid = GetPlatform.isAndroid;
    if (isAndroid) {
      plataforma = 'Android';
    } else {
      plataforma = 'Ios';
    }

    Map<String, dynamic> map = {
      'token': this.token,
      'updateAt': FieldValue.serverTimestamp(),
      'platform': plataforma
    };

    return map;
  }

  Future<void> saveToken() async {
    String token = await FirebaseMessaging().getToken();
    this.token = token;
    
    await updateData();
  }

  @override
  String toString(){
    return 'email: $email, name: $name, admin: $admin';
  }
}
