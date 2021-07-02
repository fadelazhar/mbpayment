import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mbpayment/screens/account/account.dart';
import 'package:mbpayment/screens/auth/google_signin.dart';
import 'package:mbpayment/screens/auth/login.dart';
import 'package:mbpayment/screens/balance/balance.dart';
import 'package:mbpayment/screens/home/drawer.dart';
import 'package:mbpayment/screens/settings/settings.dart';
import 'package:mbpayment/screens/transactionhistory/transaction_history.dart';
import 'package:mbpayment/screens/transfer/transfer_menu.dart';
import 'package:mbpayment/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Home extends StatelessWidget {
  String _selectedItem = '';
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  final auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser!;

  Widget _calluserName() {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Home',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _callUserBalance(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 15),
          padding: EdgeInsets.all(10),
          height: 255,
          width: 355,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            color: Colors.white,
            shape: BoxShape.rectangle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 10,
              )
            ],
          ),
          child: InkWell(
            splashColor: Colors.grey,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 25),
                  Text(
                    'Current Balance',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }
                      return Container(
                        child: Text(
                            'RM ${snapshot.data!.data()!['money'].toString()}',
                            style: TextStyle(
                              fontSize: 35,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            )),
                      );
                    },
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(child: Divider()),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
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
                                onTap: () =>
                                    _onButtonPressed(context), // button pressed
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.qr_code,
                                      color: Colors.black,
                                    ), // icon
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
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
                                onTap: () => wPushTo(
                                    context, TransferMenu()), // button pressed
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.send,
                                      color: Colors.black,
                                    ), // icon
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
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
                                onTap: () => wPushTo(context,
                                    TransactionHistory()), // button pressed
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.history,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _latestTransactions(BuildContext context) {
    return Container(
      child: Align(
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.all(10),
          height: 310,
          width: 385,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            color: Colors.white,
            shape: BoxShape.rectangle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 10,
              )
            ],
          ),
          child: Stack(
            children: [
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('transactionHistory')
                      // .where('SenderEmail', isEqualTo: user.email)
                      // .where('RecipientEmail', isEqualTo: user.email)
                      // .where(user.email.toString(), arrayContainsAny: ['SenderEmail', 'RecipientEmail'])
                      // .where(user.email.toString(), whereIn: ["SenderEmail","RecipientEmail"])
                      .orderBy('TimeDate', descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 140),
                          child: Text(
                            'No Transaction\nData Found',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    } else if (snapshot.data!.docs.length < 1) {
                      return Container(
                        alignment: Alignment.center,
                        child: Text(
                          'No Transaction\nData Found',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      );
                    } else {
                      return Container(
                        child: ListView.builder(
                          itemCount:
                              snapshot.hasData ? snapshot.data!.docs.length : 0,
                          itemBuilder: (context, index) {
                            if (snapshot.data!.docs[index]
                                    .get('RecipientEmail')
                                    .toString() ==
                                user.email) {
                              return Card(
                                child: ListTile(
                                  title: Text(
                                    '${snapshot.data!.docs[index].get('SenderEmail').toString()}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                      'Details: ${snapshot.data!.docs[index].get('RecipientReference').toString()}\nDate: ${snapshot.data!.docs[index].get('DTime').toString()}'),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.green,
                                    ),
                                  ),
                                  trailing: Text(
                                    'RM ${snapshot.data!.docs[index].get('AmountReceived').toString()}',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ),
                              );
                            } else if (snapshot.data!.docs[index]
                                    .get('SenderEmail')
                                    .toString() ==
                                user.email) {
                              return Card(
                                child: ListTile(
                                  title: Text(
                                    '${snapshot.data!.docs[index].get('RecipientEmail').toString()}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    'Details: ${snapshot.data!.docs[index].get('RecipientReference').toString()}\nDate: ${snapshot.data!.docs[index].get('DTime').toString()}',
                                    maxLines: 3,
                                  ),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.remove,
                                      color: Colors.red,
                                    ),
                                  ),
                                  trailing: Text(
                                    'RM ${snapshot.data!.docs[index].get('AmountReceived').toString()}',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              );
                            } else {
                              return Text('');
                            }
                          },
                        ),
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _homeButtons(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 10,
            ),
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
                      onTap: () => _onButtonPressed(context), // button pressed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.qr_code,
                            color: Colors.black,
                          ), // icon
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 30,
            ),
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
                      onTap: () =>
                          wPushTo(context, TransferMenu()), // button pressed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.send,
                            color: Colors.black,
                          ), // icon
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 30,
            ),
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
                      onTap: () => wPushTo(
                          context, TransactionHistory()), // button pressed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.history,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _textDividerHome() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              'Latest Transactions',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(child: Divider()),
        ],
      ),
    );
  }

  Widget _textDividerHeader() {
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 13,
                ),
                _calluserName(),
                _textDividerHeader(),
                SizedBox(
                  height: 10,
                ),
                // _currentBalance(),
                _callUserBalance(context),
                // _homeButtons(context),
                _textDividerHome(),
                SizedBox(height: 10),
                _latestTransactions(context),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  // Pop Up QR Scan Menu
  void _onButtonPressed(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            child: Container(
              child: _buildBottomNavigationMenu(),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                ),
              ),
            ),
          );
        });
  }

  Column _buildBottomNavigationMenu() {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.all(10),
          child: Icon(Icons.drag_handle),
        ),
        Container(
          child: Row(
            children: <Widget>[
              Expanded(child: Divider()),
            ],
          ),
        ),
        SizedBox(height: 5),
        Text(
          'QR Code',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        SizedBox(height: 5),
        Text('Scan to transfer money'),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: <Widget>[
              Expanded(child: Divider()),
            ],
          ),
        ),
        QrImage(
          data: user.email.toString(),
          size: 200,
          backgroundColor: Colors.white,
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: <Widget>[
              Expanded(child: Divider()),
            ],
          ),
        ),
        Text('User ID:', style: TextStyle(fontWeight: FontWeight.bold)),
        Text(user.uid),
        SizedBox(
          height: 5,
        ),
        Divider(),
        SizedBox(
          height: 5,
        ),
        Text(
          'Swipe down to close',
          style: TextStyle(fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
