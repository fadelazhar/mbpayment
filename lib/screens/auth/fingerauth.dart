import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mbpayment/screens/home/home.dart';
import 'package:mbpayment/widgets/widgets.dart';

class FingerAuth extends StatefulWidget {
  const FingerAuth({Key? key}) : super(key: key);
  @override
  _FingerAuthState createState() => _FingerAuthState();
}

class _FingerAuthState extends State<FingerAuth> {
  LocalAuthentication _fingerauth = LocalAuthentication();
  bool _checkBio = false;
  bool _isBioFinger = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
    _listBioAndFindFingerType();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Flutter Biometric Testing'),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(
                // Icons.fingerprint_rounded,
                // size: 50,
                Icons.lock_rounded,
                size: 50,
              ),
              onPressed: _startFingerAuth,
              iconSize: 60,
            ),
            SizedBox(height: 15),
            Text('tap to authenticate')
          ],
        ),
      ),
    );
  }

  void _checkBiometrics() async {
    try {
      final bio = await _fingerauth.canCheckBiometrics;
      setState(() {
        _checkBio = bio;
      });
      print('Biometrics = ${_checkBio}');
    } catch (e) {}
  }

  void _listBioAndFindFingerType() async {
    List<BiometricType> ?_listType;
    try {
      _listType = await _fingerauth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e.message);
    }

    print('List Biometrics = $_listType');

    if(_listType!.contains(BiometricType.fingerprint)){
      setState(() {
        _isBioFinger = true;
      });
      print('Fingerprint is $_isBioFinger');
    }
  }

  void _startFingerAuth () async {
    bool _isAuthenticated = false;
    AndroidAuthMessages _androidMsg = AndroidAuthMessages(
      // signInTitle: 'Biometric authentication',
      biometricHint: '',
      // cancelButton: 'Close',
    );
    try{
        _isAuthenticated = await _fingerauth.authenticate(
        localizedReason: 'Please scan your biometric or use PIN to continue',
        useErrorDialogs: true,
        stickyAuth: true,
        androidAuthStrings: _androidMsg,
      );
    } on PlatformException catch (e) {
      print(e.message);
    }

    if(_isAuthenticated)  {
          wAppLoading(context);
          wPushTo(context, Home());
    }

  }

}


