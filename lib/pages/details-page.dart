import 'package:baby_shop/models/cart-model.dart';
import 'package:baby_shop/utils/App-constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Details extends StatelessWidget {
  final String pId;
  final String pName;
  final String pImage;
  final int pRate;

  const Details({
    required this.pName,
    required this.pImage,
    required this.pRate,
    required this.pId,
  });
  Future<void> addToCart(cartItem items) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(items.productId);

    final cartItemSnp = await cartRef.get();

    if (cartItemSnp.exists) {
      cartRef.update({'quantity': FieldValue.increment(items.quantity)});
    } else {
      cartRef.set(items.tomap());
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Expanded(
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(image: NetworkImage(pImage)),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(pName, style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text("Rs $pRate"),
                  Row(
                    children: [
                      Text(
                        "Old price",
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Divider(thickness: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Appconstant.maincolor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(child: Text("4.5")),
                          ),
                          Text(
                            "20+ reviews",
                            style: TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                      Divider(thickness: 2),
                    ],
                  ),
                  Text(
                    "Description",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("Imported bags"),
                  Center(
                    child:
                    ElevatedButton(
                      onPressed: () async {
                        final itemP = cartItem(
                          productId: pId,
                          productName: pName,
                          productPrice: pRate,
                          quantity: 1,
                        );
                        await addToCart(itemP);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Appconstant.maincolor,
                            content: Text('Product added to cart'),
                          ),
                        );
                      },
                      child: Text(
                        "Add to Cart",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(backgroundColor: Appconstant.maincolor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
