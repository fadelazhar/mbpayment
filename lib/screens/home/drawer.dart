import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mbpayment/screens/account/account.dart';
import 'package:mbpayment/screens/auth/google_signin.dart';
import 'package:mbpayment/screens/auth/login.dart';
import 'package:mbpayment/screens/settings/settings.dart';
import 'package:mbpayment/screens/transactionhistory/transaction_history.dart';
import 'package:mbpayment/screens/transfer/transfer_menu.dart';
import 'package:mbpayment/widgets/widgets.dart';
import 'package:provider/provider.dart';

import 'home.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
              builder: (context, snapshot) {
                if(!snapshot.hasData) {
                  return CircularProgressIndicator();
                } else {
                  return UserAccountsDrawerHeader(
                    accountName: Text(
                      '${snapshot.data!.data()!['name'].toString()}',
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.bold),
                    ),
                    accountEmail: Text(
                      user.email!,
                      style: TextStyle(color: Colors.black54),
                    ),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                        child: Image.network(
                          '${snapshot.data!.data()!['avatar'].toString()}',
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white60,
                    ),
                  );
                }
              }
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => wPushTo(context, Home()),
          ),
          ListTile(
            leading: Icon(Icons.attach_money),
            title: Text('Transfer'),
            onTap: () => wPushTo(context, TransferMenu()),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Transaction History'),
            onTap: () => wPushTo(context, TransactionHistory()),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Account'),
            onTap: () => wPushTo(context, Account()),
          ),
          Divider(),
          ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log Out'),
              onTap: () async {
                final provider =
                Provider.of<GoogleSignInProvider>(context, listen: false);
                if (provider.googleSignIn.currentUser == null) {
                  auth.signOut();
                  wShowToast("User Logged Out");
                  wPushReplaceTo(context, Login());
                } else {
                  await provider.googleSignIn.signOut();
                  await FirebaseAuth.instance.signOut();
                  wShowToast("Google Logged Out");
                  wPushReplaceTo(context, Login());
                }
              }),
        ],
      ),
    );
  }
}
