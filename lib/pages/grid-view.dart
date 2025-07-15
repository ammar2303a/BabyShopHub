import 'package:baby_shop/pages/details-page.dart';
import 'package:baby_shop/utils/single-product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/auth-ui/welcome-page.dart';
import '../utils/App-constant.dart';
import '../utils/drawer-page.dart';

class gridview extends StatelessWidget {
  final String id;
  final String collection;

  const gridview({required this.id, required this.collection});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Material(
              elevation: 7,
              shadowColor: Colors.grey[100],
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Search Here',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
          FutureBuilder(
            future:
                FirebaseFirestore.instance
                    .collection('categories')
                    .doc(id)
                    .collection('products')
                    .get(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              print('➡️ Firebase Path: categories/$id/$collection');
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              return GridView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  var data = snapshot.data!.docs[index];
                  return showproducts(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) => Details(
                                pName: data['productName'],
                                pImage: data['productImage'],
                                pRate: data['productPrice'], pId: 'productId',
                              ),
                        ),
                      );
                    },
                    productTitle: data['productName'],
                    productImage: data['productImage'],
                    produtPrice: data['productPrice'],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
