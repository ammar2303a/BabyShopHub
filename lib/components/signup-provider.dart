import 'package:baby_shop/pages/home-page.dart';
import 'package:baby_shop/utils/App-constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/admin-panel.dart';

class SignupProvider with ChangeNotifier {
  UserCredential? userCredential;
  bool loading = false;
  void SignupValidation({
    required TextEditingController? username,
    required TextEditingController? useremail,
    required TextEditingController? userpass,
    required BuildContext context,
  }) async {
    if (username!.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Appconstant.maincolor,
          content: Text('Username is required'),
        ),
      );
      return;
    } else if (useremail!.text.isEmpty) {
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
    } else if (userpass!.text.length <= 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Appconstant.maincolor,
          content: Text('Password must cannot be less than 8 chracters'),
        ),
      );
      return;
    } else
      try {
        loading = true;
        notifyListeners();
        (userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: useremail.text,
              password: userpass.text,
            ));

        loading = true;
        notifyListeners();
        
        FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential!.user!.uid)
            .set({
              'userId': userCredential!.user!.uid,
              'fullname': username.text,
              'emailadress': useremail.text,
          'streetadress': '',
          'country': '',
          'phoneNo': '',

            });
        // 🔍 Check if user is an admin (from admin collection)
        final adminDoc = await FirebaseFirestore.instance
            .collection('admin')
            .doc(userCredential!.user!.uid)
            .get();

        print("User UID: ${userCredential!.user!.uid}");
        print("Admin role: ${adminDoc.data()?['role']}");

        loading = false;
        notifyListeners();

        if (adminDoc.exists && adminDoc.data()?['role'] == 'admin') {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AdminPanel()),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      } on FirebaseAuthException catch (e) {
        loading = false;
        notifyListeners();
        String message = "Something went wrong";

        if (e.code == "weak-password") {
          message = "Weak Password entered!";
        } else if (e.code == "email-already-in-use") {
          message = "Email already registered!";
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Appconstant.maincolor,
            content: Text(message),
          ),
        );
      }
  }
}