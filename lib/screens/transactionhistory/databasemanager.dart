import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseManager {
  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  final history = FirebaseFirestore.instance.collection('transactionHistory');
  
  Future getTransactionHistory() async {
    List historyList = [];

    try {
      await history.get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          historyList.add(element.data);
        });
      });
      return historyList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
