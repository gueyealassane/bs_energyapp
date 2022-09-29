import 'dart:io';

import 'package:bsenergy/screens/sale.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:qrscan/qrscan.dart' as scanner;
import '../widgets/MyDrawer.dart';


class Scanqrcode extends StatefulWidget {
  const Scanqrcode({Key? key}) : super(key: key);

  @override
  _ScanqrcodeState createState() => _ScanqrcodeState();
}

class _ScanqrcodeState extends State<Scanqrcode> {

  final GlobalKey _qrkey = GlobalKey();
  QRViewController? controller;
  Barcode? result;
  void _onQRViewCreated(QRViewController controller) {
      this.controller = controller;

    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });

     if(result != null ){
          controller.pauseCamera();
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => Sales(
              results: result?.code,
            )),
          );
      }
    }
    );
      controller.pauseCamera();
      controller.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
  @override
  void reassemble() async {
    super.reassemble();

    if(Platform.isAndroid){
      await controller!.pauseCamera();
    } else if (Platform.isIOS) {
        controller!.resumeCamera();
  }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  height: 400,
                  width:400,
                  child: QRView(
                    key: _qrkey,
                    onQRViewCreated: _onQRViewCreated,
                    overlay: QrScannerOverlayShape(
                      borderColor: Theme.of(context).accentColor,
                      borderRadius: 10,
                      borderLength: 20,
                      borderWidth: 10,
                      cutOutSize: MediaQuery.of(context).size.width * 0.8,
                    ) ,

                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: (result !=null) ? Text('${result!.code}') : const Text('Scan a code'),
                ),
              ),
            ],
          )
      ),
    );
  }
}




