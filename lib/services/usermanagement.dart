import 'dart:async';


import 'package:bsenergy/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthentcationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Users? _userFromFirebaseUser(User? user) {
      if (user != null) {
        return Users(uid: user.uid);
      }
        return null;
  }
  Stream<Users?> get user{
      return _auth.authStateChanges().map(_userFromFirebaseUser);
  }


    Future SignInWithEmailAndPassword(String email, String password) async {
        try{
            UserCredential result =
                await _auth.signInWithEmailAndPassword(
                email: email, password: password);
            User? user = result.user;
            return _userFromFirebaseUser(user!);
        }catch(e){

          return null;
        }

    }

    Future signOut() async {
        try {
              return await _auth.signOut();
        }catch(e){
            return null ;
        }
    }
}