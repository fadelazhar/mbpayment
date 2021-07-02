import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mbpayment/screens/account/account.dart';
import 'package:mbpayment/screens/auth/login.dart';
import 'package:mbpayment/screens/home/home.dart';
import 'package:mbpayment/screens/settings/settings.dart';
import 'package:mbpayment/screens/transactionhistory/transaction_history.dart';
import 'package:mbpayment/widgets/widgets.dart';

class Balance extends StatelessWidget {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  final auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          key: _globalKey,
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text('User Email:', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),),
                  accountEmail: Text(user.email!, style: TextStyle(color: Colors.black54),),
                  currentAccountPicture: CircleAvatar(
                    child: ClipOval(
                      child: Image.network(
                        'https://d1nhio0ox7pgb.cloudfront.net/_img/o_collection_png/green_dark_grey/512x512/plain/user.png',
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white60,
                    // image: DecorationImage(
                    //   image: NetworkImage(
                    //     'https://wallpaperaccess.com/full/1706745.jpg',
                    //   ),
                    //       fit: BoxFit.cover,
                    // ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                  onTap: () => wPushTo(context, Home()),
                ),
                ListTile(
                  leading: Icon(Icons.attach_money),
                  title: Text('Transfer'),
                  onTap: () => wPushTo(context, Balance()),
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
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: () => wPushTo(context, SettingMenu()),
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Log Out'),
                  onTap: () => wPushReplaceTo(context, Login()),
                ),
              ],
            ),
          ),
          body: Stack(
            children: [
              IconButton(
                  icon: Icon(Icons.menu),
                  color: Colors.black,
                  onPressed: () {
                    _globalKey.currentState!.openDrawer();
                  }
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 300),
                    Text('Balance', style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }

}