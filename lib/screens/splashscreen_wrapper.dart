import 'package:bsenergy/screens/authenticate_screen.dart';
import 'package:bsenergy/screens/customer.dart';
import 'package:bsenergy/screens/message.dart';
import 'package:bsenergy/screens/sale.dart';
import 'package:bsenergy/screens/scanqrcode.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';

class SplashScreenWrapper extends StatelessWidget {
  const SplashScreenWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);
    CollectionReference roles = FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(
        future: roles.doc(user?.uid).get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (kDebugMode) {
            print(user);
          }
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (user == null) {
            return AuthenticateScreen();
          } else {
            return const Scanqrcode();
          }
        });
  }
}
