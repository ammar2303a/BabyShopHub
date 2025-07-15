import 'dart:math';

import 'package:baby_shop/models/cart-model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/App-constant.dart';

class checkoutPage extends StatefulWidget {
  final List<cartItem> itemcart;
  checkoutPage({required this.itemcart});

  @override
  State<checkoutPage> createState() => _checkoutPageState();
}

class _checkoutPageState extends State<checkoutPage> {
  final formkey = GlobalKey<FormState>();
  final adress = TextEditingController();
  final phone = TextEditingController();
  final city = TextEditingController();
  final fullnameController = TextEditingController();

  // ✅ Tracking ID generator function
  String generateTrackingId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return 'TRK' + List.generate(8, (index) => chars[random.nextInt(chars.length)]).join();
  }

  int calctotalPrice() {
    int total = 0;
    for (var item in widget.itemcart) {
      total += item.quantity * item.productPrice;
    }
    return total;
  }

  Future<void> confirmOrder() async {
    if (formkey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;

      final orderData = {
        'userId': user!.uid,
        'email': user.email,
        'fullname': fullnameController.text,
        'item': widget.itemcart.map((item) => {
          'productId': item.productId,
          'productName': item.productName,
          'productPrice': item.productPrice,
          'quantity': item.quantity,
        }).toList(),
        'address': adress.text,
        'phone': phone.text,
        'city': city.text,
        'totalPrice': calctotalPrice(),
        'timestamp': DateTime.now(),

        // ✅ New fields
        'trackingId': generateTrackingId(),
        'orderStatus': 'Pending',
      };

      try {
        await FirebaseFirestore.instance.collection('orders').add(orderData);
        print("✅ Order saved successfully");
      } catch (e) {
        print("❌ Error while saving order: $e");
      }

      final batch = FirebaseFirestore.instance.batch();

      for (final item in widget.itemcart) {
        final carItemtRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .doc(item.productId);
        batch.delete(carItemtRef);
      }
      await batch.commit();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Appconstant.maincolor,
          content: Text('Order placed successfully'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = calctotalPrice();

    return Scaffold(
      appBar: AppBar(title: Text('Checkout')),
      body: Form(
        key: formkey,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: [
              TextFormField(
                controller: fullnameController,
                decoration: InputDecoration(labelText: 'FullName'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter Fullname';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: adress,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: phone,
                decoration: InputDecoration(labelText: 'Phone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter Phone';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: city,
                decoration: InputDecoration(labelText: 'City'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter City';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await confirmOrder();
                },
                child: Text(
                  'Confirm Order',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Appconstant.maincolor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
