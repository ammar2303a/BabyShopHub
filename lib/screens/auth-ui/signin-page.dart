import 'package:baby_shop/components/signin-provider.dart';
import 'package:baby_shop/screens/auth-ui/signup-page.dart';
import 'package:baby_shop/utils/App-constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInpage extends StatefulWidget {
  @override
  State<SignInpage> createState() => _SignInpageState();
}

class _SignInpageState extends State<SignInpage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool visibility = true;

  @override
  Widget build(BuildContext context) {
    SigninProvider signinProvider = Provider.of<SigninProvider>(context);
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
              "Login into your account",
              style: TextStyle(color: Appconstant.maincolor, fontSize: 16),
            ),
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
                    visibility ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
                hintStyle: TextStyle(color: Appconstant.placeholder),
              ),
            ),

            SizedBox(height: 20),

            signinProvider.loading == false
                ? ElevatedButton(
              onPressed: () {
                signinProvider.SigninValidation(
                  useremail: email,
                  userpass: password,
                  context: context,
                );
              },
              child: Text('SignIn'),
            )
                : Center(child: CircularProgressIndicator()),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Dont have an account? "),
                GestureDetector(
                  onTap: () {
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (context) => Signup()));
                  },
                  child: Text(
                    'SignUp',
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
