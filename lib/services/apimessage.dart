
import 'package:bsenergy/models/response.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('messages');


class ApiMessage{

  double price_essence = 1600;
  double price_gazoil  = 1200;

  Future addmessage(Response response) async {

    final docMessage = _mainCollection.doc();
    final json  = response.toJson();
    await docMessage.set(json);

  }



}