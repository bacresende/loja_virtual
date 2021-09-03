import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class Delivery {
  static Future<double> calculateDelivery(double lat, double long) async {
    Firestore db = Firestore.instance;

    DocumentSnapshot doc = await db.collection('aux').document('delivery').get();

    double latBanco = doc.data['lat'];
    double longBanco = doc.data['long'];
    num maxkm = doc.data['maxkm'];

    double dis = await Geolocator().distanceBetween(lat, long, latBanco, longBanco);

    dis = dis / 1000;
    //String distancia = (dis/1000).toStringAsFixed(2);
    double taxaDeEntrega;
    
    if (dis <= maxkm) {
      if (dis <= 3) {
        taxaDeEntrega = 3;
      } else if (dis > 3 && dis <= 6) {
        taxaDeEntrega = 5;
      } else {
        taxaDeEntrega = 9;
      }

      return taxaDeEntrega;
    } else {
      return taxaDeEntrega;
    }
  }
}
