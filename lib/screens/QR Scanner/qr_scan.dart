import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mbpayment/screens/transfer/transfer_process_qr.dart';
import 'package:mbpayment/widgets/widgets.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanPage extends StatefulWidget {
  @override
  _QRScanPageState createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  final qrKey = GlobalKey(debugLabel: 'QR');

  Barcode? barcode;
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();

    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          body: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              buildQrView(context),
              Positioned(bottom: 30, child: buildControlButtons()),
            ],
          ),
        ),
      );

  Widget buildControlButtons() => Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            ButtonBar(
              alignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: FutureBuilder<bool?>(
                    future: controller?.getFlashStatus(),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        return Icon(
                          snapshot.data! ? Icons.flash_on : Icons.flash_off,
                          color: Colors.white,
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  onPressed: () async {
                    await controller?.toggleFlash();
                    setState(() {});
                  },
                ),
                IconButton(
                  icon: FutureBuilder(
                    future: controller?.getCameraInfo(),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        return Icon(
                          Icons.switch_camera,
                          color: Colors.white,
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  onPressed: () async {
                    await controller?.flipCamera();
                    setState(() {});
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
          ],
        ),
      );

  Widget title() => Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: Colors.white24),
        child: Text(
          'QR Scanner',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );

  Widget buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRpop,
        overlay: QrScannerOverlayShape(
          borderColor: Colors.white,
          borderRadius: 10,
          borderLength: 20,
          borderWidth: 5,
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
        ),
      );

  void onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);

    controller.scannedDataStream
        .listen((barcode) => setState(() => this.barcode = barcode));
    if (mounted) {
      controller.dispose();
      Navigator.pop(context, barcode!.code);
      wShowToast(barcode!.code);
    }
  }

  void onQRpop(QRViewController controller) {
    setState(() => this.controller = controller);

    controller.scannedDataStream.listen((barcode) {
      print(barcode.code);
      if (mounted) {
        controller.dispose();
        var route = new MaterialPageRoute(
            builder: (BuildContext context) => new TransferProcessQR(
                    value: PassdataQR(
                  email: barcode.code.toString(),
                )));
        Navigator.of(context).push(route);
      }
    });
  }
}

class PassdataQR {
  final String? email;
  const PassdataQR({
    this.email,
  });
}
