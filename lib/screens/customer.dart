import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Customer extends StatefulWidget {
  const Customer({Key? key}) : super(key: key);

  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  final Stream<QuerySnapshot> _soldStream = FirebaseFirestore.instance
      .collection('vente_carburant')
      .where("uidusers", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Mes Transactions'),
          backgroundColor: Colors.blue,
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: _soldStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text("Oupsss.......");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: SpinKitCircle(
                  size: 140,
                  color: Colors.blue,
                ));
              } else {
                return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic>? data =
                        document.data()! as Map<String, dynamic>?;
                    print(data!['nomclient']);
                    return Card(
                      elevation: 5,
                      child: ListTile(
                        leading: const Icon(Icons.account_balance_wallet),
                        title:  (data['nomclient'] !=null) ? Text('${data['nomclient']}') : const Text('null'),
                        subtitle: Text(data['carburant'] +" " +data['quantite'].toString() + "L"),
                        trailing: const Icon(Icons.accessibility),
                      ),
                    );
                  }).toList(),
                );
              }
            }));
  }
}
