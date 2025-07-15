import 'package:baby_shop/models/cart-model.dart';
import 'package:baby_shop/pages/checkout-page.dart';
import 'package:baby_shop/utils/App-constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/order-model.dart';

final userId = FirebaseAuth.instance.currentUser!.uid;

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(backgroundColor: Appconstant.maincolor),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .collection('cart')
                .snapshots(),
        builder: (context, snpindex) {
          if (!snpindex.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final itemCart =
              snpindex.data!.docs
                  .map((doc) => cartItem.fromDocument(doc))
                  .toList();

          if (itemCart.isEmpty) {
            return Center(child: Text('Your cart is empty'));
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: itemCart.length,
                  itemBuilder: (context, index) {
                    final item = itemCart[index];
                    return ListTile(
                      title: Text(item.productName),
                      subtitle: Row(
                        children: [
                          IconButton(
                            onPressed: () async {
                             if(item.quantity >1){
                               await updateCartItem(item.productId, item.quantity-1);
                             }
                            },
                            icon: Icon(Icons.remove),
                          ),
                          Text('${item.quantity}'),
                          IconButton(onPressed: () async {
                            await updateCartItem(item.productId, item.quantity+1);
                          }, icon: Icon(Icons.add)),
                        ],
                      ),
                      trailing: Text(
                        'Rs: ${item.productPrice * item.quantity}',
                        style: TextStyle(color: Colors.green),
                      ),
                      leading: IconButton(
                        onPressed: () async {
                          await removeCartItem(item.productId);
                        },
                        icon: Icon(Icons.delete),
                        color: Colors.red,
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () async {
                    // await checkout(itemCart);
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(
                    //       backgroundColor: Appconstant.maincolor,
                    //       content: Text('Product added to cart'),
                    //     ));
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>checkoutPage(itemcart: itemCart)));
                  },
                  child: Text(
                    'Proceed to checkout',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Appconstant.maincolor,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Future<void> removeCartItem(String productId) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('cart')
      .doc(productId)
      .delete();
}

Future<void> updateCartItem(String productId, int newquantity) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('cart')
      .doc(productId)
      .update({'quantity' : newquantity});
}

Future<void> checkout(List<cartItem> itemCart) async {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final orderId = FirebaseFirestore.instance.collection('orders').doc().id;

  final orderitem =
  itemCart.map((item) {
    return OrderItem(
      productId: item.productId,
      productName: item.productName,
      quantity: item.quantity,
      productPrice: item.productPrice,
    );
  }).toList();

  final order = Orders(
    id: orderId,
    items: orderitem,
    totalPrice: itemCart.fold(
      0,
          (sum, item) => sum + item.productPrice * item.quantity,
    ),
    timestamp: DateTime.now(),
  );

  final orderRef = FirebaseFirestore.instance.collection('users').doc(userId).collection('orders').doc(orderId);

  final batch = FirebaseFirestore.instance.batch();

  batch.set(orderRef, order.toMap());

  for(final item in itemCart){
    final carItemtRef = FirebaseFirestore.instance.collection('users').doc(userId).collection('cart').doc(item.productId);
    batch.delete(carItemtRef);


  }
  batch.commit();
}