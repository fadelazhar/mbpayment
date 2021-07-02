import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

String? uValidator({
  @required String? value,
  bool isRequired = false,
  bool isEmail = false,
  bool notSame = false,
  int? minLength,
  String? match,
}) {
  if (isRequired) {
    if (value!.isEmpty) {
      return 'Required';
    }
  }

  if (notSame) {
    if (value! == FirebaseAuth.instance.currentUser!.email) {
      return 'Cannot transfer to your own account';
    }
  }

  if (isEmail) {
    if (!value!.contains('@') || !value.contains('.')) {
      return 'Invalid Email';
    }
  }

  if (minLength != null) {
    if (value!.length < minLength) {
      return 'Min $minLength character';
    }
  }

  if(match != null){

    if(value != match){
      return 'Does not match your password';
    }
  }





  return null;
}
