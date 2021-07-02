import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mbpayment/screens/auth/google_signin.dart';
import 'package:mbpayment/screens/auth/login.dart';
import 'package:mbpayment/screens/auth/welcome_modal.dart';
import 'package:mbpayment/screens/home/home.dart';
import 'package:mbpayment/utils/utils.dart';
import 'package:mbpayment/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

//Functions
TextEditingController _name = TextEditingController();
TextEditingController _email = TextEditingController();
TextEditingController _password = TextEditingController();
TextEditingController _passwordconf = TextEditingController();
GlobalKey<FormState> _formKey = GlobalKey<FormState>();

CollectionReference ref = FirebaseFirestore.instance.collection('users');

final auth = FirebaseAuth.instance;
final user = FirebaseAuth.instance.currentUser!;
final db = FirebaseFirestore.instance;
bool _obsecureText = true;

bool _isLoading = false;

// Register Box
class _RegisterState extends State<Register> {
  Widget _authTitle() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Register',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 3),
          Text('Fill in the form to register')
        ],
      ),
    );
  }

  // Input Name
  Widget _inputName() {
    return Container(
      child: TextFormField(
        textCapitalization: TextCapitalization.words,
        controller: _name,
        decoration: InputDecoration(
          hintText: 'Name',
          helperText: 'Enter full name',
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 0.0),
          ),
          border: const OutlineInputBorder(),
        ),
        validator: (val) => uValidator(
          value: val,
          isRequired: true,
          minLength: 3,
        ),
      ),
    );
  }

  // Input Email
  Widget _inputEmail() {
    return Container(
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: _email,
        decoration: InputDecoration(
          hintText: 'Email',
          helperText: 'Enter email',
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
    return Column(
      children: [
        Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                controller: _password,
                obscureText: _obsecureText,
                decoration: InputDecoration(
                  hintText: '******',
                  helperText: 'Enter Password',
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  border: const OutlineInputBorder(),
                ),
                validator: (val) => uValidator(
                  value: val,
                  isRequired: true,
                  minLength: 6,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextFormField(
                controller: _passwordconf,
                obscureText: _obsecureText,
                decoration: InputDecoration(
                  hintText: '*******',
                  helperText: 'Confirm Password',
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  border: const OutlineInputBorder(),
                ),
                validator: (val) => uValidator(
                    value: val,
                    isRequired: true,
                    minLength: 6,
                    match: _password.text),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: IconButton(
                  icon: Icon(
                    _obsecureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey[600],
                  ),
                  onPressed: () {
                    setState(() => _obsecureText = !_obsecureText);
                  },
                ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _inputPasswordConfirmation() {
    return Column(
      children: <Widget>[

      ],
    );
  }

  // Submit Button
  Widget _inputSubmit() {
    return Container(
      width: double.infinity,
      child: RaisedButton(
        color: Theme.of(context).primaryColor,
        shape: StadiumBorder(),
        child: Text('Register'),
        onPressed: () async {
          if (!_formKey.currentState!.validate()) return;
          setState(() => _isLoading = true);
          try {
            await auth.createUserWithEmailAndPassword(
                email: _email.text, password: _password.text);
            await db.collection('users').doc(user.uid).set({
              'money': 0,
              'email': _email.text,
              'name': _name.text,
              'users ID': user.uid,
              'avatar':
              'https://firebasestorage.googleapis.com/v0/b/mobile-payment-application.appspot.com/o/files%2Fdefault%2Fuser.png?alt=media&token=65babdbf-9399-4676-9653-52ac98a79358',
            }).then((_) {
              print('success!!');
              wPushReplaceTo(context, Login());
              showModalBottomSheet(
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (builder) {
                    return WelcomeModal();
                  });
            });
          } on FirebaseAuthException catch (e) {
            return wShowToast(e.message.toString());
          }
        },
      ),
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

  // Google Register
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
          await db.collection('users').doc(user.uid).set({
            'money': 0,
            'email': user.email,
            'name': user.displayName,
            'users ID': user.uid,
          }).then((_) {
            wShowToast("Login Successful");
            wPushReplaceTo(context, Home());
          });
        },
      ),
    );
  }

  // Already have an account Button
  Widget _textLogin() {
    return Container(
      margin: EdgeInsets.only(top: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Already have an account?'),
          GestureDetector(
              child: Container(
                padding: EdgeInsets.all(10),
                color: Colors.transparent,
                child: Text(
                  'Log In',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              onTap: () => wPushReplaceTo(context, Login()))
        ],
      ),
    );
  }

  // Full Register Screen
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: SafeArea(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        _authTitle(),
                        _inputName(),
                        SizedBox(height: 10),
                        _inputEmail(),
                        SizedBox(height: 10),
                        _inputPassword(),
                        SizedBox(
                          height: 30,
                        ),
                        _inputSubmit(),
                        _textDivider(),
                        _googleSignIn(),
                        _textLogin(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
