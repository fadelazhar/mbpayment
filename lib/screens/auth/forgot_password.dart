import 'package:flutter/material.dart';
import 'package:mbpayment/providers/auth_provider.dart';
import 'package:mbpayment/utils/utils.dart';
import 'package:mbpayment/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _email = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Widget _inputEmail() {
    return Container(
      child: TextFormField(
        controller: _email,
        keyboardType: TextInputType.emailAddress,
        decoration:
            InputDecoration(hintText: 'Email', helperText: 'Enter your email'),
        validator: (val) => uValidator(
          value: val,
          isRequired: true,
          isEmail: true,
        ),
      ),
    );
  }

  // Submit Button
  Widget _inputSubmit() {
    return Container(
      width: double.infinity,
      child: RaisedButton(
        color: Theme.of(context).primaryColor,
        shape: StadiumBorder(),
        child: Text('Send'),
        onPressed: () {
          if (!_formKey.currentState!.validate()) return;
          final auth = Provider.of<AuthProvider>(context, listen: false);
          setState(() => _isLoading = true);
          auth.resetPassword(
            context: context,
            email: _email.text,


          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: _isLoading
          ? wAppLoading(context)
          : Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.black),
              ),
              resizeToAvoidBottomInset: false,
              body: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      wAuthTitle(),
                      _inputEmail(),
                      SizedBox(
                        height: 30,
                      ),
                      _inputSubmit(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
