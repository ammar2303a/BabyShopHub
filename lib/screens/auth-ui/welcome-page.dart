import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:baby_shop/screens/auth-ui/signin-page.dart';
import 'package:baby_shop/utils/App-constant.dart';
import 'package:flutter/material.dart';

class Welcomepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(child: Image.asset('assets/treepanda.png')),
            Container(
              alignment: Alignment.center,
              child: AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(
                    'Fun Shopping for Little Stars!',
                    textStyle: TextStyle(

                      fontSize: 18,                      // pehle jaisa size
                            // pehle jaisa weight
                      color: Colors.green,               // pehle jaisa color
                    ),
                    speed: Duration(milliseconds: 80),
                  ),
                ],
                totalRepeatCount: 1,
                displayFullTextOnTap: true,
                stopPauseOnTap: true,
              ),
            ),


            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignInpage()));
              },
              label: Text('Sign in with email',style: TextStyle(color: Colors.green),),
              icon: Icon(Icons.email,color: Appconstant.maincolor,),
            ),
          ],
        ),
      ),
    );
  }
}
