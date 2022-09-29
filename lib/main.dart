import 'package:bsenergy/models/user.dart';
import 'package:bsenergy/screens/splashscreen_wrapper.dart';
import 'package:bsenergy/services/usermanagement.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyBOpQxt9eWvU3AJT7M6KCkIrdWgE6-rGoE",
          appId: "bsenergy-93bf1",
          messagingSenderId: "304450624288",
          projectId: "bsenergy-93bf1",
        ),
    );
  runApp(Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<Users?>.value(
        value: AuthentcationService().user,
        initialData: null,
      builder: (context, snapshot) {
        return MaterialApp(
          home: SplashScreenWrapper(),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
        );
      }
    );
  }
}
