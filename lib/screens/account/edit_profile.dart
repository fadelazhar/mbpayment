import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mbpayment/screens/account/account.dart';
import 'package:mbpayment/utils/utils.dart';
import 'package:mbpayment/widgets/widgets.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  final auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser!;
  final db = FirebaseFirestore.instance;
  bool _isLoading = false;
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  var idListForSender = [];
  var idListForRecipient = [];
  final ImagePicker _picker = ImagePicker();
  File? file;

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? Path.basename(file!.path) : 'No File Selected';
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              child: Center(
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 13),
                            Stack(children: <Widget>[
                              Align(
                                alignment: Alignment.topLeft,
                                child: IconButton(
                                  onPressed: () =>
                                      wPushReplaceTo(context, Account()),
                                  icon: Icon(Icons.arrow_back_ios_outlined),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    'Edit Profile',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            ]),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                  ),
                                  Expanded(child: Divider()),
                                ],
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Current Avatar:',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 5),
                            StreamBuilder<
                                    DocumentSnapshot<Map<String, dynamic>>>(
                                stream: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.uid)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return CircularProgressIndicator();
                                  } else {
                                    return ClipOval(
                                      child: Image.network(
                                              '${snapshot.data!.data()!['avatar'].toString()}',
                                              width: 90,
                                              height: 90,
                                              fit: BoxFit.cover,
                                            ),
                                    );
                                  }
                                }),
                            SizedBox(height: 10),
                            RaisedButton(
                              splashColor: Colors.grey,
                              color: Colors.white,
                              shape: StadiumBorder(),
                              child: Text(
                                'Change Avatar',
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () => updateAvatar(context),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                  ),
                                  Expanded(child: Divider()),
                                ],
                              ),
                            ),
                            StreamBuilder<
                                    DocumentSnapshot<Map<String, dynamic>>>(
                                stream: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.uid)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return CircularProgressIndicator();
                                  } else {
                                    return Text(
                                      'Current Name: ${snapshot.data!.data()!['name'].toString()}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                      ),
                                      textAlign: TextAlign.center,
                                    );
                                  }
                                }),
                            SizedBox(height: 5),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Form(
                                key: _formKey,
                                child: TextFormField(
                                  controller: _name,
                                  decoration: InputDecoration(
                                    enabledBorder: const OutlineInputBorder(
                                      // width: 0.0 produces a thin "hairline" border
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 0.0),
                                    ),
                                    border: const OutlineInputBorder(),
                                    hintText: 'Name',
                                    helperText: 'Enter new name',
                                  ),
                                  validator: (val) => uValidator(
                                    value: val,
                                    isRequired: true,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            RaisedButton(
                              splashColor: Colors.grey,
                              color: Colors.white,
                              shape: StadiumBorder(),
                              child: Text(
                                'Change Name',
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate())
                                  return updateName();
                              },
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                  ),
                                  Expanded(child: Divider()),
                                ],
                              ),
                            ),
                            Text(
                              'Email:',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              '${snapshot.data!.data()!['email'].toString()}',
                              style: TextStyle(fontSize: 15),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 15),
                            RaisedButton(
                              splashColor: Colors.grey,
                              color: Colors.white,
                              shape: StadiumBorder(),
                              child: Text(
                                'Update Email',
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () {
                                updateEmailModal();
                              },
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                  ),
                                  Expanded(child: Divider()),
                                ],
                              ),
                            ),
                            Text(
                              'User Id:',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              '${user.uid}',
                              style: TextStyle(fontSize: 15),
                              textAlign: TextAlign.center,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                  ),
                                  Expanded(child: Divider()),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  updateName() async {
    await db.collection('users').doc(user.uid).update({
      'name': _name.text,
    }).then((_) {
      wShowToast('Name updated!');
      // wPushReplaceTo(context, Account());
    });
  }

  updateEmailModal() async {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (builder) {
        return Container(
          height: MediaQuery.of(context).size.height / 1.6,
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          child: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.all(10),
                child: Icon(Icons.drag_handle),
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 25),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                    ),
                    Text(
                      'Current Email: ${user.email}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Form(
                        key: _formKey2,
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _email,
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              // width: 0.0 produces a thin "hairline" border
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 0.0),
                            ),
                            border: const OutlineInputBorder(),
                            hintText: 'Email',
                            helperText: 'Enter new email',
                          ),
                          validator: (val) => uValidator(
                            value: val,
                            isRequired: true,
                            isEmail: true,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: <Widget>[
                          Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.all(10),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                    ),
                    RaisedButton(
                      splashColor: Colors.grey,
                      color: Colors.white,
                      shape: StadiumBorder(),
                      child: Text(
                        'Update Email',
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () async {
                        if (_formKey2.currentState!.validate())
                          return updateEmail();
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  updateAvatar(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (builder) {
        return Container(
          height: MediaQuery.of(context).size.height / 6.4,
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          child: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.all(10),
                child: Icon(Icons.drag_handle),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 25),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              Align(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton.icon(
                        shape: StadiumBorder(),
                        icon: Icon(Icons.image),
                        label: Text('Gallery'),
                        onPressed: () async {
                          await getAvatar(ImageSource.gallery);
                          wShowToast('Press save to complete update');
                        },
                      ),
                      SizedBox(width: 45),
                      FlatButton.icon(
                        shape: StadiumBorder(),
                        icon: Icon(Icons.save),
                        label: Text('Save'),
                        onPressed: () async {
                          uploadAvatar();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future getAvatar(ImageSource source) async {
    final result = await ImagePicker().getImage(source: ImageSource.gallery);

    if (result == null) return;
    final path = result.path;

    setState(() => file = File(path));
  }

  Future uploadAvatar() async {
    if(file == null) return;

    final fileName = Path.basename(file!.path);
    final destination = 'files/${user.uid}/$fileName';

    FirebaseApi.uploadFile(destination, file!);
    String downloadUrl = await firebase_storage.FirebaseStorage.instance.ref(destination).getDownloadURL();
    print(downloadUrl);
    await db.collection('users').doc(user.uid).update({
      'avatar': downloadUrl,
    }).then((_) => wShowToast('Uploaded'));
  }

  updateEmail() async {
    try {
      await user.updateEmail(_email.text).then((value) => print('Success'));
      await db.collection('users').doc(user.uid).update({
        'email': _email.text,
      }).then((_) async {
        var senderEmailRef = await db
            .collection('transactionHistory')
            .where('SenderEmail', isEqualTo: user.email.toString())
            .get();
        senderEmailRef.docs.forEach((element) {
          idListForSender.add(element.id);
          print("ID SENDER: " + element.id.toString());
        });

        var recipientEmailRef = await db
            .collection('transactionHistory')
            .where('RecipientEmail', isEqualTo: user.email.toString())
            .get();
        recipientEmailRef.docs.forEach((element) {
          idListForRecipient.add(element.id);
          print("ID RECIPIENT: " + element.id.toString());
        });

        WriteBatch batch = db.batch();
        for (var i = 0; i < idListForSender.length; i++) {
          var senderAccouunt = db
              .collection('transactionHistory')
              .doc(idListForSender[i].toString());
          batch.update(senderAccouunt, {"SenderEmail": _email.text.toString()});
          print(i.toString() +
              " IDLISTFORSENDER: " +
              idListForSender[i].toString());
        }

        for (var i = 0; i < idListForRecipient.length; i++) {
          var recipientAccount = db
              .collection('transactionHistory')
              .doc(idListForRecipient[i].toString());
          batch.update(
              recipientAccount, {"RecipientEmail": _email.text.toString()});
          print(i.toString() +
              " IDLISTFORRECIPIENT: " +
              idListForRecipient[i].toString());
        }

        await batch.commit();
        wShowToast('Email updated!');
        // wPushReplaceTo(context, Account());
      });
    } on FirebaseAuthException catch (e) {
      return wShowToast(e.message.toString());
    }
  }
}

class FirebaseApi {
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }
}
