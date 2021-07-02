import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mbpayment/screens/QR%20Scanner/qr_scan.dart';
import 'package:mbpayment/screens/QR%20Scanner/scanner.dart';
import 'package:mbpayment/screens/account/account.dart';
import 'package:mbpayment/screens/auth/login.dart';
import 'package:mbpayment/screens/home/drawer.dart';
import 'package:mbpayment/screens/home/home.dart';
import 'package:mbpayment/screens/settings/settings.dart';
import 'package:mbpayment/screens/transactionhistory/transaction_history.dart';
import 'package:mbpayment/screens/transfer/transfer_contacts.dart';
import 'package:mbpayment/screens/transfer/transfer_process.dart';
import 'package:mbpayment/utils/utils.dart';
import 'package:mbpayment/widgets/widgets.dart';

class TransferMenu extends StatefulWidget {
  const TransferMenu({Key? key}) : super(key: key);

  @override
  _TransferMenuState createState() => _TransferMenuState();
}

class _TransferMenuState extends State<TransferMenu> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  TextEditingController _email = TextEditingController();
  final auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser!;
  final db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  String? _result;

  // Buttons
  Widget _transferButtons(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // SizedBox.fromSize(
            //   size: Size(70, 70), // button width and height
            //   child: Container(
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(60),
            //         boxShadow: [
            //           BoxShadow(
            //             color: Colors.grey,
            //             spreadRadius: 2,
            //             blurRadius: 6,
            //             offset: Offset(0, 1),
            //           )
            //         ]),
            //     child: ClipOval(
            //       child: Material(
            //         color: Colors.white, // button color
            //         child: InkWell(
            //           splashColor: Colors.grey, // splash color
            //           onTap: () => wPushTo(
            //               context, TransferContacts()), // button pressed
            //           child: Column(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: <Widget>[
            //               Icon(
            //                 Icons.contacts,
            //                 color: Colors.black,
            //               ), // icon
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   width: 70,
            // ),
            SizedBox.fromSize(
              size: Size(70, 70), // button width and height
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
                    color: Colors.white, // button color
                    child: InkWell(
                      splashColor: Colors.grey, // splash color
                      onTap: () => _openScanner(context),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.qr_code_scanner,
                            color: Colors.black,
                            size: 34,
                          ), // icon
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  RaisedButton sendButton(String _amount) {
    return RaisedButton(
      color: Colors.green,
      shape: StadiumBorder(),
      child: Text(
        'Send',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () async {},
    );
  }

  // Input Email
  Widget _inputEmail() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, snapshot) {
          return Container(
            width: 355,
            padding: EdgeInsets.only(bottom: 20),
            child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: _email,
                validator: (val) => uValidator(
                  value: val,
                  isRequired: true,
                  isEmail: true,
                  notSame: true,
                ),
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    // width: 0.0 produces a thin "hairline" border
                    borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  border: const OutlineInputBorder(),
                  hintText: 'Email',
                  helperText: 'Enter Recipient Email',
                ),
              ),
          );
        });
  }

  Widget _textDividerTransfer() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
          ),
          Expanded(child: Divider()),
        ],
      ),
    );
  }

  Widget _nextButton (BuildContext context) {
    return Container(
      child: RaisedButton(
        splashColor: Colors.grey,
        color: Colors.white,
        shape: StadiumBorder(),
        child: Text(
          'Next',
          style: TextStyle(color: Colors.black),
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            await FirebaseFirestore.instance
                .collection('users')
                .where('email', isEqualTo: _email.text)
                .get()
                .then((snapshot) => print(snapshot.docs[0].id));
            var route = new MaterialPageRoute(
                builder: (BuildContext context) => new TransferProcess(
                    value: Passdata(
                      email: _email.text,
                    )));
            Navigator.of(context).push(route);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          key: _globalKey,
          drawer: DrawerWidget(),
          body: Stack(
            children: [
              IconButton(
                  icon: Icon(Icons.menu),
                  color: Colors.black,
                  onPressed: () {
                    _globalKey.currentState!.openDrawer();
                  }),
              Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 13),
                      Text(
                        'Send To',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      _textDividerTransfer(),
                      _transferButtons(context),
                      _textDividerTransfer(),
                      _inputEmail(),
                      _textDividerTransfer(),
                      _nextButton(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Future _openScanner(BuildContext context) async {
    final barcode = await wPushTo(context, QRScanPage());
    // final result = await wPushTo(context, Scanner());
    // _result = result;
    _result = barcode;
  }
}

class Passdata {
  final String? email;

  const Passdata({
    this.email,
  });
}
