import 'package:baby_shop/components/signup-provider.dart';
import 'package:baby_shop/screens/auth-ui/signin-page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/App-constant.dart';

class Signup extends StatefulWidget {
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool visibility = true;
  @override
  Widget build(BuildContext context) {
    SignupProvider signupProvider = Provider.of<SignupProvider>(context);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Appconstant.appname,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Appconstant.maincolor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(child: Image.asset('assets/babypanda.png', height: 200)),
            SizedBox(height: 20),
            Text(
              "Create your account",
              style: TextStyle(color: Appconstant.maincolor, fontSize: 16),
            ),
            TextFormField(
              controller: name,
              decoration: InputDecoration(
                hintText: 'Username',
                hintStyle: TextStyle(color: Appconstant.placeholder),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: email,
              decoration: InputDecoration(
                hintText: 'Email',
                hintStyle: TextStyle(color: Appconstant.placeholder),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              obscureText: visibility,
              controller: password,
              decoration: InputDecoration(
                hintText: 'Password',
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      visibility = !visibility;
                    });
                  },
                  icon: Icon(
                    visibility ? Icons.visibility_off : Icons.visibility
                  ),
                ),
                hintStyle: TextStyle(color: Appconstant.placeholder),
              ),
            ),
            SizedBox(height: 20),
            signupProvider.loading == false
                ? ElevatedButton(
                  onPressed: () {
                    signupProvider.SignupValidation(
                      username: name,
                      useremail: email,
                      userpass: password,
                      context: context,
                    );
                  },
                  child: Text('SignUp'),
                )
                : Center(child: CircularProgressIndicator()),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?  "),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SignInpage()),
                    );
                  },
                  child: Text(
                    'SignIn',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
