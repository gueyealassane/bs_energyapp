
import 'package:bsenergy/models/sold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('vente_carburant');


class ApiSold{



  Future addsold(Sold sold) async {

      final docSold = _mainCollection.doc();
      final json  = sold.toJson();
      await docSold.set(json);

  }

}