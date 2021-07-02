import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Scanner extends StatefulWidget {
  const Scanner({Key? key}) : super(key: key);

  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  bool _flashOn = false;
  bool _frontCam = false;
  GlobalKey _qrKey = GlobalKey();
  QRViewController? _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          QRView(
            key: _qrKey,
            overlay: QrScannerOverlayShape(),
            onQRViewCreated: (QRViewController? controller){
              this._controller = controller;
              controller!.scannedDataStream.listen((val){
                if(mounted){
                  _controller!.dispose();
                  Navigator.pop(context, val);
                }
              });
            },
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: 60),
              child: Text(
                'Scanner',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ButtonBar(
              alignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  color: Colors.white,
                  icon: Icon(_flashOn ? Icons.flash_on : Icons.flash_off),
                  onPressed: () {
                    setState(() {
                      _flashOn = !_flashOn;
                    });
                    _controller!.toggleFlash();
                  },
                ),
                IconButton(
                  color: Colors.white,
                  icon:
                  Icon(_frontCam ? Icons.camera_front : Icons.camera_rear),
                  onPressed: () {
                    setState(() {
                      _frontCam = !_frontCam;
                    });
                    _controller!.flipCamera();
                  },
                ),
                IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
