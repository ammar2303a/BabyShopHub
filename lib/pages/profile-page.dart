import 'package:baby_shop/pages/home-page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/auth-ui/welcome-page.dart';
import '../utils/App-constant.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
TextEditingController userName = TextEditingController(text: usermodel?.UserName);
TextEditingController userEmail = TextEditingController(text: usermodel?.UserEmail);
TextEditingController streetAdress = TextEditingController(text: usermodel?.streetadress);
TextEditingController country = TextEditingController(text: usermodel?.country);
TextEditingController PhoneNo = TextEditingController(text: usermodel?.phoneNo);
  bool isEdit = false;

  Widget textField({required hintText}) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Material(
        elevation: 5,
        shadowColor: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
        child: Container(
          margin: EdgeInsets.all(10),

          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: ListTile(
            leading: Text(
              hintText,
              style: TextStyle(color: Colors.pinkAccent, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

  Widget nonEditTextfield() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/babypanda.png'),
              radius: 50,
            ),
          ],
        ),
        SizedBox(height: 20),
        textField(hintText: usermodel?.UserName ?? 'guest'),
        textField(hintText: usermodel?.UserEmail ?? 'guest@gmail.com'),
        textField(hintText: usermodel?.streetadress),
        textField(hintText: usermodel?.country),
        textField(hintText: usermodel?.phoneNo),
      ],
    );
  }

  Widget EditTextfield() {
    return Column(

      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/babypanda.png'),
              radius: 50,
            ),
          ],
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: userName,
          decoration: InputDecoration(hintText: usermodel?.UserName ?? 'guest'),
        ),
        TextFormField(
          controller: userEmail,
          decoration: InputDecoration(
            hintText: usermodel?.UserEmail ?? 'guest@gmail.com',
          ),
        ),
        TextFormField(
          controller: streetAdress,
          decoration: InputDecoration(hintText: streetAdress.text.isEmpty ? 'Street Address': null,
            hintStyle: TextStyle(color: Colors.grey.shade400),
          ),
        ),
        TextFormField(
          controller: country,
          decoration: InputDecoration(hintText: country.text.isEmpty ? 'Country Name': null,
            hintStyle: TextStyle(color: Colors.grey.shade400),
          ),

        ),
        TextFormField(
          controller: PhoneNo,
          decoration: InputDecoration(hintText: PhoneNo.text.isEmpty ? 'Enter Phone Number': null,
            hintStyle: TextStyle(color: Colors.grey.shade400),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            updateprofile();
          },
          child: Text(
            'Update',
            style: TextStyle(color: Colors.green),
          ),
        ),
      ],
    );
  }
  Future updateprofile() async{
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).
    update({
      'fullname': userName.text,
      'emailadress': userEmail.text,
      'streetadress': streetAdress.text,
      'country': country.text,
      'phoneNo': PhoneNo.text,
    }).then((value) =>  Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage())));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading:
            isEdit
                ? IconButton(
                  onPressed: () {
                    setState(() {
                      isEdit = false;
                    });
                  },
                  icon: Icon(Icons.close, color: Colors.white),
                )
                : IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isEdit = true;
              });
            },
            icon: Icon(Icons.edit, color: Colors.white),
          ),
        ],
        title: Text(
          Appconstant.appname,
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: Appconstant.maincolor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              isEdit ? EditTextfield(): nonEditTextfield()
            ],
          )
        ),
      ),
    );
  }
}
