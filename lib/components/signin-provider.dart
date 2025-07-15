import 'package:baby_shop/pages/home-page.dart';
import 'package:baby_shop/utils/App-constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/admin-panel.dart';

class SigninProvider with ChangeNotifier {
  UserCredential? userCredential;
  bool loading = false;

  void SigninValidation({

    required TextEditingController? useremail,
    required TextEditingController? userpass,
    required BuildContext context,
  }) async {
    if (useremail!.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Appconstant.maincolor,
          content: Text('Email is required'),
        ),
      );
      return;
    } else if (userpass!.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Appconstant.maincolor,
          content: Text('Password is required'),
        ),
      );
      return;
    } else
      try {
        loading = true;
        notifyListeners();
        userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: useremail.text,
          password: userpass.text,
        );

// 🔍 Admin role check
        final adminDoc = await FirebaseFirestore.instance
            .collection('admin')
            .doc(userCredential!.user!.uid)
            .get();

        print("User UID: ${userCredential!.user!.uid}");
        print("Admin role: ${adminDoc.data()?['role']}");

        loading = false;
        notifyListeners();

        if (adminDoc.exists && adminDoc.data()?['role'] == 'admin') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AdminPanel()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }

      } on FirebaseAuthException catch (e) {
        loading = true;
        notifyListeners();
        if (e.code == "user-not-found") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Appconstant.maincolor,
              content: Text('User does not exist!'),
            ),
          );
        } else if (e.code == "wrong-password") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Appconstant.maincolor,
              content: Text('Incorrect password'),
            ),
          );
        }
      }
  }
}
