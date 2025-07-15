import 'package:baby_shop/pages/view-orders-admin.dart';
import 'package:baby_shop/pages/view-products-page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/auth-ui/welcome-page.dart';
import '../utils/App-constant.dart';
import 'add-category-page.dart';
import 'add-product-page.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  Widget currentPage = Center(child: Text("Welcome Admin 👋"));

  void setPage(Widget page) {
    setState(() {
      currentPage = page;
      Navigator.pop(context); // Drawer close ho jaye
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut().then(
                    (value) => Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => Welcomepage())),
              );
            },
            icon: Icon(Icons.exit_to_app, color: Colors.white),
          ),
        ],
        title: Text("Admin Panel",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.pink,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.pink),
              child: Center(
                child: Text(
                  'Admin Controls',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.add_box),
              title: Text('Add Product'),
              onTap: () => setPage(AddProductPage()),
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: Text('Add Category'),
              onTap: () => setPage(AddCategoryPage()),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => ViewOrdersAdmin()));
              },
              child: Text("View Orders",style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Appconstant.maincolor),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => ViewProductsPage()));
              },
              child: Text("View Products",style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Appconstant.maincolor),
            ),

          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: currentPage,
      ),
    );
  }
}
