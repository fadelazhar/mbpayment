import 'package:flutter/material.dart';
import 'package:mbpayment/screens/auth/fingerauth.dart';

 class FingerPrint extends StatelessWidget {

   @override
   Widget build(BuildContext context) {
     return MaterialApp(
     debugShowCheckedModeBanner: false,
     title: 'Flutter Biometric',
     home: FingerAuth(),
     );
   }
 }
