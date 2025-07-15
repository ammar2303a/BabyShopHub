import 'package:baby_shop/pages/cart-page.dart';
import 'package:baby_shop/pages/home-page.dart';
import 'package:baby_shop/pages/profile-page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/my-orders-page.dart';
import '../screens/auth-ui/welcome-page.dart';
import 'App-constant.dart';

class drawerBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Appconstant.maincolor
            ),
            accountName: Text(usermodel?.UserName ?? 'Guest'),
            accountEmail: Text(usermodel?.UserEmail ?? 'guest@gmail.com'),

            currentAccountPicture:  CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(
                "assets/babypanda.png",
              ),
            ),

          ),
          // ListTile(
          //   leading: IconButton(
          //     onPressed: () {},
          //     icon: Icon(Icons.home, color: Colors.green),
          //   ),
          //   title: Text("Home"),
          // ),
          ListTile(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage() ));
              },
              icon: Icon(Icons.person, color: Colors.green),
            ),
            title: Text("Profile"),
          ),
          ListTile(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => CartPage() ));
              },
              icon: Icon(Icons.add_shopping_cart),
            ),
            title: Text("Cart"),
          ),
          ListTile(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MyOrdersPage(),
                ));
              },
              icon: Icon(Icons.receipt_long, color: Colors.deepPurple),
            ),
            title: Text("My Orders"),
          ),
          ListTile(
            leading: IconButton(
              onPressed: () {},
              icon: Icon(Icons.payment, color: Colors.blueAccent),
            ),
            title: Text("Payment"),
          ),
          ListTile(
            leading: IconButton(onPressed: () {}, icon: Icon(Icons.wallet)),
            title: Text("Wallet"),
          ),
          ListTile(
            leading: IconButton(
              onPressed: () {},
              icon: Icon(Icons.favorite, color: Colors.red),
            ),
            title: Text("Favourites"),
          ),
          ListTile(
            leading: IconButton(
              onPressed: () {},
              icon: Icon(Icons.notification_add, color: Colors.yellow),
            ),
            title: Text("Notifications"),
          ),
          ListTile(
            leading: IconButton(onPressed: () {}, icon: Icon(Icons.help)),
            title: Text("Help!"),
          ),
          ListTile(
            leading: IconButton(
              onPressed: () {},
              icon: Icon(Icons.settings, color: Colors.grey),
            ),
            title: Text("Settings"),
          ),
          ListTile(
            leading: IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then(
                  (value) => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Welcomepage()),
                  ),
                );
              },
              icon: Icon(Icons.logout),
            ),
            title: Text("LogOut"),
          ),
        ],
      ),
    );
  }
}
