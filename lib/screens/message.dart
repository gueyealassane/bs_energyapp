import 'package:bsenergy/models/response.dart';
import 'package:bsenergy/services/apimessage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../common/constants.dart';

class Message extends StatefulWidget {
  const Message({Key? key}) : super(key: key);

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  final controllertitle = TextEditingController();
  final controllermessage = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Espace Support',
              style: TextStyle(fontSize: 20),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: controllermessage,
                minLines: 2,
                maxLines: 50,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                    hintText: "Vos Suggestions et recommandations",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    )),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  final response = Response(
                    message: controllermessage.text,
                    email: auth.currentUser?.email,
                    date: DateTime.now(),
                  );
                  ApiMessage().addmessage(response);
                  setState(() {
                    controllermessage.text = '';
                  });
                },
                child: Text("Envoyer Message"))
          ],
        ),
      ),
    );
  }
}
