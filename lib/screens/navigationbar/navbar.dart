import 'package:flutter/material.dart';
import 'package:mbpayment/screens/account/account.dart';
import 'package:mbpayment/screens/auth/login.dart';
import 'package:mbpayment/screens/balance/balance.dart';
import 'package:mbpayment/screens/home/home.dart';
import 'package:mbpayment/screens/settings/settings.dart';
import 'package:mbpayment/screens/transactionhistory/transaction_history.dart';
import 'package:mbpayment/widgets/widgets.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('Remy the Rat Dev'),
            accountEmail: Text('demo@dev.com'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  'https://64.media.tumblr.com/bd421e4d5ee3f758bdc0542ab09328ec/7dd14ab0d9573e57-a4/s400x600/336ada64c0323fc57c4f2b78e58e95fe417c809d.png',
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ),


            decoration: BoxDecoration(
              color: Colors.black54,
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
            title: Text('Balance'),
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
    );
  }
}
