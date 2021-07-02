import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mbpayment/providers/auth_provider.dart';
import 'package:mbpayment/widgets/widgets.dart';
import 'package:provider/provider.dart';

class WelcomeModal extends StatefulWidget {
  const WelcomeModal({Key? key}) : super(key: key);

  @override
  _WelcomeModalState createState() => _WelcomeModalState();
}

class _WelcomeModalState extends State<WelcomeModal> {
  bool _isLoading = false;
  bool _isSent = false;
  final auth = FirebaseAuth.instance;
  LocalAuthentication _fingerauth = LocalAuthentication();
  bool _checkBio = false;
  bool _isBioFinger = true;

  Widget _checkBioButton() {
    return Column(
      children: <Widget>[
        Text('Check available biometrics on your phone:'),
        SizedBox(height: 25),
        SizedBox.fromSize(
          size: Size(70, 70),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: Offset(0, 1),
                  )
                ]),
            child: ClipOval(
              child: Material(
                color: Colors.white,
                child: InkWell(
                  splashColor: Colors.grey, // splash color
                  onTap: () => _listBioAndFindFingerType(), // button pressed
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.fingerprint,
                        color: Colors.black,
                      ), // icon
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _resendEmailMsg() {
    return Container(
      child: Text(
        'Email Sent!',
        style: TextStyle(color: Colors.green),
      ),
    );
  }

  Widget _bottomWidget() {
    return _isSent ? _resendEmailMsg() : _checkBioButton();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.6,
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.all(10),
            child: Icon(Icons.drag_handle),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Divider(
              height: 40,
              indent: 50,
              endIndent: 50,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.money,
                  size: 50,
                ),
                SizedBox(height: 20),
                Text(
                  'Welcome to Secure E-Wallet',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'An app where you can have a secure\nmobile transactions.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5),
                Divider(
                  height: 40,
                  indent: 50,
                  endIndent: 50,
                ),
                Text(
                  'Secure E-Wallet uses your smartphone\'s built-in\nBiometrics Authentication',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Divider(
                  height: 40,
                  indent: 50,
                  endIndent: 50,
                ),
                _bottomWidget()
              ],
            ),
          )
        ],
      ),
    );
  }

  void _checkBiometrics() async {
    try {
      final bio = await _fingerauth.canCheckBiometrics;
      setState(() {
        _checkBio = bio;
      });
      wShowToast('Biometrics Available:\n${_checkBio}');
    } catch (e) {wShowToast(e.toString());}
  }

  void _listBioAndFindFingerType() async {
    List<BiometricType> ?_listType;
    try {
      _listType = await _fingerauth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e.message);
    }

    print('List Biometrics = $_listType');

    if(_listType!.contains(BiometricType.fingerprint) && _listType.contains(BiometricType.face)){
      setState(() {
        _isBioFinger = true;
      });
      wShowToast('Fingerprint and Face ID is $_isBioFinger');
    }
    else if (_listType.contains(BiometricType.face)){
      setState(() {
        _isBioFinger = true;
      });
      wShowToast('Face ID is $_isBioFinger');
    } else if (_listType.contains(BiometricType.fingerprint)){
      setState(() {
        _isBioFinger = true;
      });
      wShowToast('Fingerprint is $_isBioFinger');
    } else if (_listType.contains(BiometricType.iris) && _listType.contains(BiometricType.face)){
      setState(() {
        _isBioFinger = true;
      });
      wShowToast('Iris is $_isBioFinger');
    } else if (_listType.contains(BiometricType.fingerprint) && _listType.contains(BiometricType.iris) && _listType.contains(BiometricType.face)){
      setState(() {
        _isBioFinger = true;
      });
      wShowToast('Fingerprint, Iris, and Face ID is $_isBioFinger');
    } else if (_listType.contains(BiometricType.fingerprint) && _listType.contains(BiometricType.iris)){
      setState(() {
        _isBioFinger = true;
      });
      wShowToast('Fingerprint and Iris is $_isBioFinger');
    }
  }
}

