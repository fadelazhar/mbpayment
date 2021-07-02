import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mbpayment/screens/auth/forgot_password.dart';
import 'package:mbpayment/screens/auth/google_signin.dart';
import 'package:mbpayment/screens/auth/register.dart';
import 'package:mbpayment/screens/home/home.dart';
import 'package:mbpayment/utils/utils.dart';
import 'package:mbpayment/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

//Functions
TextEditingController _email = TextEditingController();
TextEditingController _password = TextEditingController();
bool _obsecureText = true;
bool _isLoading = false;
GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final auth = FirebaseAuth.instance;
LocalAuthentication _fingerauth = LocalAuthentication();

// Log In Box
class _LoginState extends State<Login> {
  Widget _authTitle() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Login',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 3),
          Text('Please enter your email and password')
        ],
      ),
    );
  }

  // Input Email
  Widget _inputEmail() {
    return Container(
      child: TextFormField(
        controller: _email,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Email',
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 0.0),
          ),
          border: const OutlineInputBorder(),
        ),
        validator: (val) => uValidator(
          value: val,
          isRequired: true,
          isEmail: true,
        ),
      ),
    );
  }

  // Input Password
  Widget _inputPassword() {
    return Stack(
      children: <Widget>[
        Container(
          child: TextFormField(
              controller: _password,
              obscureText: _obsecureText,
              decoration: InputDecoration(
                hintText: 'Password',
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                ),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obsecureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey[600],
                  ),
                  onPressed: () {
                    setState(() => _obsecureText = !_obsecureText);
                  },
                ),
              ),
              validator: (val) => uValidator(
                    value: val,
                    isRequired: true,
                    minLength: 6,
                  )),
        ),
      ],
    );
  }

  // Forgot Password
  Widget _forgotPassword() {
    return GestureDetector(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.fromLTRB(0, 20, 20, 20),
            child: Text(
              'Forgot Password ?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        onTap: () => wPushTo(context, ForgotPassword()));
  }

  // Submit Button
  Widget _inputSubmit() {
    return Container(
      width: double.infinity,
      child: RaisedButton(
          color: Theme.of(context).primaryColor,
          shape: StadiumBorder(),
          child: Text('Login'),
          onPressed: () async {
            if (await _startFingerAuth() != "Failed") {
              if (!_formKey.currentState!.validate()) return;
              setState(() => _isLoading = true);
              try {
                await auth.signInWithEmailAndPassword(
                    email: _email.text, password: _password.text);
                wShowToast("Login Successful");
                return wPushReplaceTo(context, Home());
              } on FirebaseAuthException catch (e) {
                return wShowToast(e.message.toString());
              }
            } else {
              wShowToast("Authentication Failed");
            }
          }),
    );
  }

  // Text Divider
  Widget _textDivider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              'OR CONNECT WITH',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          Expanded(child: Divider()),
        ],
      ),
    );
  }

  // Google Sign In
  Widget _googleSignIn() {
    return Container(
      width: double.infinity,
      child: RaisedButton.icon(
        shape: StadiumBorder(),
        icon: Icon(
          Ionicons.logo_google,
          size: 18,
        ),
        label: Text('Google'),
        onPressed: () async {
          final provider =
          Provider.of<GoogleSignInProvider>(context, listen: false);
          await provider.googleLogin(context);
          if (await _startFingerAuth() != "Failed") {
            wShowToast("Login Successful");
            wPushReplaceTo(context, Home());
          } else {
            await provider.googleSignIn.signOut();
            await FirebaseAuth.instance.signOut();
            wShowToast("Authentication Failed");
          }
        },
      ),
    );
  }

  // Register Button
  Widget _textRegister() {
    return Container(
      margin: EdgeInsets.only(top: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Dont have an account yet?'),
          GestureDetector(
            child: Container(
              padding: EdgeInsets.all(10),
              color: Colors.transparent,
              child: Text(
                'Register',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            onTap: () => wPushReplaceTo(context, Register()),
          )
        ],
      ),
    );
  }



  // Full Login Screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.money,
                        size: 50,
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Secure E-Wallet',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _authTitle(),
                      _inputEmail(),
                      SizedBox(height: 10),
                      _inputPassword(),
                      _forgotPassword(),
                      Divider(),
                      SizedBox(height: 15),
                      _inputSubmit(),
                      _textDivider(),
                      _googleSignIn(),
                      SizedBox(height: 15),
                      Divider(),
                      _textRegister(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<String?> _startFingerAuth() async {
  bool _isAuthenticated = false;
  AndroidAuthMessages _androidMsg = AndroidAuthMessages(
    // signInTitle: 'Biometric authentication',
    biometricHint: 'To log in please authenticate',
    cancelButton: 'Close',
  );
  try {
    _isAuthenticated = await _fingerauth.authenticate(
      localizedReason: 'Please scan your biometric or use PIN to continue',
      useErrorDialogs: true,
      stickyAuth: true,
      androidAuthStrings: _androidMsg,
    );
  } on PlatformException catch (e) {
    print(e.message);
  }

  if (_isAuthenticated) {
    return "Authenticated";
  }
  return "Failed";
}