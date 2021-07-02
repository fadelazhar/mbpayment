
import 'package:flutter/material.dart';
import 'package:mbpayment/screens/auth/login.dart';
import 'package:mbpayment/screens/home/home.dart';
import 'package:mbpayment/widgets/widgets.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    _checkUserCurrently(false);
    super.initState();
  }

  @override
  // Widget build(BuildContext context) => Scaffold(
  //   body: StreamBuilder(
  //       stream: FirebaseAuth.instance.authStateChanges(),
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting)
  //           return Center(child: CircularProgressIndicator());
  //         } else if (snapshot.hasData) {
  //         return Home();
  //         } else if (snapshot.hasError) {
  //         return Center(child: Text('Something Went Wrong!'));
  //         } else {
  //         return Login();
  //        }
  //   ),
  // );

  Widget build(BuildContext context) {
    return Scaffold(body: wAppLoading(context));
  }

  void _checkUserCurrently(bool user) async {
    await Future.delayed(Duration(seconds: 2));
    wPushReplaceTo(context, user ? Home() : Login());
  }
}