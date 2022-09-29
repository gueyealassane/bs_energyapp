import 'package:bsenergy/screens/authenticate_screen.dart';
import 'package:bsenergy/screens/customer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/message.dart';
class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
           const DrawerHeader(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.deepOrange
                    ]
                )
            ),
            child:  Center(
              child: CircleAvatar(
                backgroundImage: AssetImage("images/bsenergy.jpg"),
                radius: 50,
              ),
            ),

          ),
          ListTile(
            leading: const Icon(Icons.add_business),
            title: const Text('Transactions'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context, MaterialPageRoute(builder: (BuildContext context) {
                return const Customer();
              }));
            },
          ),
          ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Message'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context, MaterialPageRoute(builder: (BuildContext context) {
                  return const Message();
                },
                ),
                );
              }
          ),
          ListTile(
              leading: const  Icon(Icons.login_outlined),
              title: const Text('Se déconnecter'),
              onTap: () async {
                await _auth.signOut();
                Navigator.of(context).pop();
                Navigator.push(
                  context, MaterialPageRoute(builder: (BuildContext context) {
                  return const AuthenticateScreen();
                },
                ),
                );

              }
          ),
        ],
      ),
    );
  }
}
