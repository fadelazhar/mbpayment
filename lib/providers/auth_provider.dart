import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mbpayment/widgets/widgets.dart';

class AuthProvider with ChangeNotifier {

  final auth = FirebaseAuth.instance;

  Future<String> getCurrentUID() async {
    String uid = (await auth.currentUser!).uid;
    return uid;
  }


  // Reset Password
  void resetPassword({@required BuildContext? context, String? email}) async {
    if (email!.isNotEmpty) {
      print('Success');
      await Future.delayed(Duration(seconds: 2));
      auth.sendPasswordResetEmail(email: email);
      wShowToast('Email sent! Please check your email to reset password.');
      Navigator.pop(context!);
    } else {
      print('Failed');
    }
  }


  // Resend Email Verification
  Future<void> resendEmailVerif() async{
    await Future.delayed(Duration(seconds: 2));

  }

}
