import 'package:bsenergy/models/sold.dart';
import 'package:bsenergy/screens/scanqrcode.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import '../services/apisold.dart';

class Sales extends StatefulWidget {
  var results;

  Sales({Key? key, required this.results}) : super(key: key);

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  final controllerquantite = TextEditingController();
  final controllercarburant = TextEditingController();
  final controllerprix_total = TextEditingController();
  final controlleruidusers = TextEditingController();
  final controlleruidclient = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  late TwilioFlutter twilioFlutter;
  final _formKey = GlobalKey<FormState>();
  void initState() {
    twilioFlutter = TwilioFlutter(
        accountSid: 'AC63397bf0d828b21f64ac4a3011d95a34',
        authToken: '4d1b775b2034fcb15545f8d5d77f11d2',
        twilioNumber: '+16282775626');
  }

  final List<String> listItems = [
    'Super',
    'Essence Ordinaire',
    'Gasoil',
    'Diesel Oil',
    'Essence Pirogue',
    'Petrole Lampant',
    'Fuel 180 et 360 HTS et BTS',
  ];

  String? selectedValue;
  double total = 200;
  final String documentId = '';

  void clearText() {
    selectedValue = null;
    controllerquantite.clear();
    controllerprix_total.clear();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    if (widget.results.runtimeType != String) {}

    return Scaffold(
        appBar: AppBar(
          title: const Text('Vente'),
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return const Scanqrcode();
                    })),
                  },
              icon: Icon(Icons.arrow_back, color: Colors.black)),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: FutureBuilder<DocumentSnapshot>(
            future: users.doc(widget.results).get(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text("les données ne sont pas disponibles");
              }

              if (snapshot.hasData && !snapshot.data!.exists) {
                return const Text("Document does not exist");
              }

              if ((snapshot.connectionState == ConnectionState.done)) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                void sendSms() async {
                  twilioFlutter.sendSMS(
                      toNumber: '${data['phone']}',
                      messageBody:
                          'Vous avez achetez ${controllerquantite.text}litres \nMontant:${controllerprix_total.text}');
                }

                return Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(0)),
                            child: DropdownButton(
                              hint: const Text("Carburant"),
                              dropdownColor: Colors.grey,
                              icon: const Icon(Icons.arrow_drop_down),
                              iconSize: 30,
                              isExpanded: true,
                              underline: const SizedBox(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                              value: selectedValue,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedValue = newValue as String?;
                                });
                              },
                              items: listItems.map((valueItem) {
                                return DropdownMenuItem(
                                  value: valueItem,
                                  child: Text(valueItem),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                              controller: controllerquantite,
                              decoration: const InputDecoration(
                                labelText: 'Nombre de Litres',
                                helperText: "",
                                border: OutlineInputBorder(),
                                suffixText: "Litres",
                              ),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Veuillez renseigner une valeur";
                                } else {
                                  return null;
                                }
                              }),
                          const SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                              controller: controllerprix_total,
                              decoration: const InputDecoration(
                                labelText: "Prix total",
                                helperText: "",
                                border: OutlineInputBorder(),
                                suffix: Text("FCFA"),
                              ),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Veuillez renseigner une valeur";
                                } else {
                                  return null;
                                }
                              }),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                              child: const Text(
                                'Vendre',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                sendSms();
                                if (_formKey.currentState!.validate()) {
                                  sendSms();
                                  final sold = Sold(
                                    carburant: selectedValue,
                                    prix_total: int.parse(controllerprix_total.text),
                                    quantite: int.parse(controllerquantite.text),
                                    uidusers: auth.currentUser?.uid,
                                    nomclient: (data['nomcomplet']).toString(),
                                    uidclients: widget.results,
                                    date: DateTime.now(),
                                  );

                                  ApiSold().addsold(sold);
                                  clearText();
                                  setState(() {
                                    selectedValue = null;
                                  });
                                } else {
                                  return;
                                }
                              }),
                          const SizedBox(
                            height: 10,
                          ),
                          Card(
                            elevation: 50.0,
                            shadowColor: Colors.black,
                            color: Colors.blue,
                            child: SizedBox(
                              width: 300,
                              height: 80,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        title: Center(
                                            child: Text(
                                          "${data['nomcomplet']}",
                                          style: const TextStyle(
                                              color: Colors.white),
                                        )),
                                        subtitle: Center(
                                            child: Text(
                                          "${data['CNI']}",
                                          style: const TextStyle(
                                              color: Colors.white),
                                        )),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return const Center(
                    child: SpinKitCircle(
                  size: 140,
                  color: Colors.blue,
                ));
              }
            }));
  }
}
