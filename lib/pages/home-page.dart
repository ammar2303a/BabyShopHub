import 'package:baby_shop/models/user-model.dart';
import 'package:baby_shop/pages/grid-view.dart';
import 'package:baby_shop/screens/auth-ui/welcome-page.dart';
import 'package:baby_shop/utils/App-constant.dart';
import 'package:baby_shop/utils/drawer-page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/single-product.dart';
import 'details-page.dart';

Usermodel? usermodel;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isloading = true;
  Future<void> getCurrentuser() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot doc) {
          if (doc.exists) {
            print('✅ Email from Firebase: ${doc['emailadress']}');
            print('✅ Fullname from Firebase: ${doc['fullname']}');
            usermodel = Usermodel.fromDucumen(doc);
          } else {
            print('Document does not exist');
          }
        });
    setState(() {
      isloading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentuser(); // ✅ build hone se pehle call hota hai
  }

  Widget build(BuildContext context) {
    // TODO: implement build
    if (isloading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      drawer: drawerBuilder(),
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
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Text(
          Appconstant.appname,
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: Appconstant.maincolor,
      ),

      body: ListView(
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
          ListTile(title: Text('Categories', style: TextStyle(fontSize: 20))),
          Container(
            height: 200,
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance
                      .collection("categories")
                      .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamsnp) {
                if (!streamsnp.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: streamsnp.data!.docs.length,
                  itemBuilder: (ctx, index) {
                    return category(
                      CategoryName: streamsnp.data!.docs[index]['categoryName'],
                      CtaegoryImage:
                          streamsnp.data!.docs[index]['categoryImage'],
                      ontap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (context) => gridview(
                                  id: streamsnp.data!.docs[index].id,
                                  collection:
                                      streamsnp
                                          .data!
                                          .docs[index]['categoryName'],
                                ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   child: Row(
          //     children: [
          //       category(
          //         CategoryName: 'Baby Care',
          //         CtaegoryImage: 'baby-care.jpg',
          //       ),
          //       category(
          //         CategoryName: 'Mothers Bags',
          //         CtaegoryImage: 'baby-bags.jpg',
          //       ),
          //       category(
          //         CategoryName: 'Baby Clothes',
          //         CtaegoryImage: 'baby-clothes.jpg',
          //       ),
          //     ],
          //   ),
          // ),
          ListTile(title: Text('Products', style: TextStyle(fontSize: 20))),
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   child: Row(
          //     children: [
          //       showproducts(
          //         productTitle: "Johnson Baby Shampoo" ,
          //         productImage: 'oil.png',
          //         produtPrice: 749,onTap: (){}
          //       ),
          //
          //     ],
          //   ),
          // ),
          Container(
            height: 260,
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("products").snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamsnp) {
                if (!streamsnp.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: streamsnp.data!.docs.length,
                  itemBuilder: (ctx, index) {
                    return showproducts(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (context) => Details(
                              pName: streamsnp.data!.docs[index]['productName'],
                              pImage: streamsnp.data!.docs[index]['productImage'],
                              pRate: streamsnp.data!.docs[index]['productPrice'],
                                    pId: streamsnp.data!.docs[index]['productId']
                            ),
                          ),
                        );
                      },
                      productTitle: streamsnp.data!.docs[index]['productName'],
                      productImage: streamsnp.data!.docs[index]['productImage'],
                      produtPrice: streamsnp.data!.docs[index]['productPrice'],
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(height: 10),
          ListTile(
            title: Text('Feature Products', style: TextStyle(fontSize: 20)),
          ),
          Container(
            height: 260,
            child: StreamBuilder(
              stream:
              FirebaseFirestore.instance.collection("products").where('productRate',isGreaterThanOrEqualTo: 4).orderBy('productRate', descending: true).snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamsnp) {
                if (!streamsnp.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: streamsnp.data!.docs.length,
                  itemBuilder: (ctx, index) {
                    return showproducts(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (context) => Details(
                              pName: streamsnp.data!.docs[index]['productName'],
                              pImage: streamsnp.data!.docs[index]['productImage'],
                              pRate: streamsnp.data!.docs[index]['productPrice'], pId: streamsnp.data!.docs[index]['productId'],
                            ),
                          ),
                        );
                      },
                      productTitle: streamsnp.data!.docs[index]['productName'],
                      productImage: streamsnp.data!.docs[index]['productImage'],
                      produtPrice: streamsnp.data!.docs[index]['productPrice'],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class category extends StatelessWidget {
  final String CategoryName;
  final String CtaegoryImage;
  final Function()? ontap;
  const category({
    required this.CategoryName,
    required this.CtaegoryImage,
    required this.ontap,
  });
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: ontap,
      child: Container(
        margin: EdgeInsets.all(12.0),
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(CtaegoryImage),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10),
        ),

        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(CategoryName, style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
