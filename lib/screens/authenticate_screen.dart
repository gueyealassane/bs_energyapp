import 'package:bsenergy/common/constants.dart';
import 'package:bsenergy/common/loading.dart';
import 'package:bsenergy/services/usermanagement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/form.dart';
import 'package:bsenergy/common/constants.dart';

class AuthenticateScreen extends StatefulWidget {
  const AuthenticateScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticateScreen> createState() => _AuthenticateScreenState();
}

class _AuthenticateScreenState extends State<AuthenticateScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void toggleView() {
    setState(() {
      _formKey.currentState?.reset();
      error = '';
      emailController.text = '';
      passwordController.text = '';
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[120],
        elevation: 0.0,
        title: Text('Bienvenue à BS ENERGY'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 30),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset('images/loginbsenergy.jpeg',
                    height: 100.0, width: 50.0),
                SizedBox(height: 15.0),
                Center(
                  child: Text(
                    '',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.blue)),
                    labelText: "Email",
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? "Entrez votre email"
                      : null,
                ),
                SizedBox(height: 15.0),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.password),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.blue)),
                    labelText: "Mot de passe",
                  ),
                  obscureText: true,
                  validator: (value) => value != null && value.length < 6
                      ? "Entrez votre mot de passe"
                      : null,
                ),
                SizedBox(height: 10.0),
                ElevatedButton(
                    child: Text(
                      "Connexion",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState?.validate() == true) {
                        setState(() => loading = true);
                        var password = passwordController.value.text;
                        var email = emailController.value.text;

                        // TODO call firebase auth
                        try{
                          dynamic result = await _auth.signInWithEmailAndPassword(
                              email: email, password: password);
                          if (result == null) {
                            setState(() {
                              loading = false;
                              error = 'Entrer un email valide';
                            });
                          }
                        }on FirebaseAuthException catch  (e) {
                          print('Failed with error code: ${e.code}');
                          print(e.message);
                          if (e.code == 'user-not-found') {
                            print('No user found for that email.');
                          } else if (e.code == 'wrong-password') {
                            print('Wrong password provided for that user.');
                          }
                        }


                      }
                    }),
                SizedBox(height: 10.0),
                Text(
                  error,
                  style: const TextStyle(color: Colors.red, fontSize: 15.0),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
