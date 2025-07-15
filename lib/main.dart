import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:baby_shop/components/signin-provider.dart';
import 'package:baby_shop/components/signup-provider.dart';
import 'package:baby_shop/pages/admin-panel.dart';
import 'package:baby_shop/pages/home-page.dart';
import 'package:baby_shop/screens/auth-ui/signin-page.dart';
import 'package:baby_shop/screens/auth-ui/welcome-page.dart';
import 'package:baby_shop/utils/App-constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SignupProvider()),
        ChangeNotifierProvider(create: (context) => SigninProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home:
        AnimatedSplashScreen(
          duration: 3000,
          splash: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/babypanda.png', height: 200),
              SizedBox(height: 20),
              DefaultTextStyle(
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Pacifico',
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText(
                      'BabyShop',
                      speed: Duration(milliseconds: 150), // typing speed
                    ),
                  ],
                  totalRepeatCount: 1, // only once
                  pause: Duration(milliseconds: 500),
                  displayFullTextOnTap: true,
                  stopPauseOnTap: true,
                ),
              ),
            ],
          ),
          nextScreen:StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, usersnp) {
          if (usersnp.hasData) {
            final userId = usersnp.data!.uid;
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('admin').doc(userId).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }

                final isAdmin = snapshot.data?.exists == true &&
                    snapshot.data?.get('role') == 'admin';

                if (isAdmin) {
                  return AdminPanel();
                } else {
                  return HomePage();
                }
              },
            );
          }
          return Welcomepage();
        },
      ),

      splashTransition: SplashTransition.fadeTransition,
          backgroundColor: Appconstant.maincolor,
          splashIconSize: 300,
        ),
      ),
    );
  }
}
