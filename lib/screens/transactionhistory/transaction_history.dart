import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mbpayment/screens/account/account.dart';
import 'package:mbpayment/screens/auth/login.dart';
import 'package:mbpayment/screens/home/drawer.dart';
import 'package:mbpayment/screens/home/home.dart';
import 'package:mbpayment/screens/settings/settings.dart';
import 'package:mbpayment/screens/transfer/transfer_menu.dart';
import 'package:mbpayment/widgets/widgets.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({Key? key}) : super(key: key);

  @override
  _TransactionHistoryState createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  final auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          shadowColor: Colors.white,
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.menu),
              color: Colors.black,
              onPressed: () {
                _globalKey.currentState!.openDrawer();
              }),
          title: Text(
            'Transaction History',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        key: _globalKey,
        drawer: DrawerWidget(),
        body: Stack(
          children: [
            SizedBox(height: 10),
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
                                    'From: ${snapshot.data!.docs[index].get('SenderEmail').toString()}'),
                                subtitle: Text(
                                    'Details: ${snapshot.data!.docs[index].get('RecipientReference').toString()}\nDate Time: ${snapshot.data!.docs[index].get('DTime').toString()}'),
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
                                    'To: ${snapshot.data!.docs[index].get('RecipientEmail').toString()}'),
                                subtitle: Text(
                                    'Details: ${snapshot.data!.docs[index].get('RecipientReference').toString()}\nDate Time: ${snapshot.data!.docs[index].get('DTime').toString()}'),
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
    );
  }
}
