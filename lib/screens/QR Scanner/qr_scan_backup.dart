// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:mbpayment/screens/transfer/transfer_process_qr.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
//
// class QRScanPage extends StatefulWidget {
//   @override
//   _QRScanPageState createState() => _QRScanPageState();
// }
//
// class _QRScanPageState extends State<QRScanPage> {
//   final qrKey = GlobalKey(debugLabel: 'QR');
//
//   Barcode? barcode;
//   QRViewController? controller;
//
//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
//
//   @override
//   void reassemble() async {
//     super.reassemble();
//
//     if (Platform.isAndroid) {
//       await controller!.pauseCamera();
//     }
//     controller!.resumeCamera();
//   }
//
//   @override
//   Widget build(BuildContext context) => SafeArea(
//     child: Scaffold(
//       body: Stack(
//         alignment: Alignment.center,
//         children: <Widget>[
//           buildQrView(context),
//           Positioned(top: 10, child: buildControlButtons()),
//         ],
//       ),
//     ),
//   );
//
//
//
//   Widget buildControlButtons() => Container(
//     padding: EdgeInsets.symmetric(horizontal: 16),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(8),
//       color: Colors.white24,
//     ),
//     child: Row(
//       mainAxisSize: MainAxisSize.max,
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: <Widget>[
//         IconButton(
//           icon: FutureBuilder<bool?>(
//             future: controller?.getFlashStatus(),
//             builder: (context, snapshot) {
//               if (snapshot.data != null) {
//                 return Icon(
//                     snapshot.data! ? Icons.flash_on : Icons.flash_off);
//               } else {
//                 return Container();
//               }
//             },
//           ),
//           onPressed: () async {
//             await controller?.toggleFlash();
//             setState(() {});
//           },
//         ),
//         IconButton(
//           icon: FutureBuilder(
//             future: controller?.getCameraInfo(),
//             builder: (context, snapshot) {
//               if (snapshot.data != null) {
//                 return Icon(Icons.switch_camera);
//               } else {
//                 return Container();
//               }
//             },
//           ),
//           onPressed: () async {
//             await controller?.flipCamera();
//             setState(() {});
//           },
//         ),
//       ],
//     ),
//   );
//
//   Widget buildResult() => Container(
//     padding: EdgeInsets.all(12),
//     decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8), color: Colors.white24),
//     child: Text(
//         barcode != null ? _dataFetch() : 'Scan a code!',
//         maxLines: 3,
//         if
//     ),
//   );
//
//
//   // Widget buildResult() {
//   //   if(barcode != null) {
//   //     print(barcode!.code);
//   //   } else {
//   //     print("failed");
//   //   }
//   // }
//
//   _dataFetch() async {
//     if (barcode == null) {
//       print('error');
//     } else {
//       var route = new MaterialPageRoute(
//           builder: (BuildContext context) =>
//           new TransferProcessQR(
//               value: PassdataQR(
//                 email: barcode!.code.toString(),
//               )
//           )
//       );
//       Navigator.of(context).push(route);
//     }
//   }
//
//   Widget buildQrView(BuildContext context) => QRView(
//     key: qrKey,
//     onQRViewCreated: onQRViewCreated,
//     overlay: QrScannerOverlayShape(
//       borderColor: Colors.white,
//       borderRadius: 10,
//       borderLength: 20,
//       borderWidth: 10,
//       cutOutSize: MediaQuery.of(context).size.width * 0.8,
//     ),
//   );
//
//   void onQRViewCreated(QRViewController controller) {
//     setState(() => this.controller = controller);
//
//     controller.scannedDataStream
//         .listen((barcode) => setState(() => this.barcode = barcode));
//     // if (barcode == null) {
//     //   print('error');
//     // } else {
//     //   print(barcode!.code.toString());
//     //   var route = new MaterialPageRoute(
//     //       builder: (BuildContext context) =>
//     //       new TransferProcessQR(
//     //           value: PassdataQR(
//     //             email: barcode!.code.toString(),
//     //           )
//     //       )
//     //   );
//     //   Navigator.of(context).push(route);
//     // }
//   }
// }
//
// class PassdataQR {
//   final String? email;
//
//   const PassdataQR ({
//     this.email,
//   });
// }