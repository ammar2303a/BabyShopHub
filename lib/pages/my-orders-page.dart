import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(title: Text("My Orders")),
        body: Center(child: Text("User not logged in")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("My Orders")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("You haven't placed any orders yet."));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var order = snapshot.data!.docs[index];
              List items = order['item'];
              String? status = order.data().toString().contains('orderStatus') ? order['orderStatus'] : null;
              String? tracking = order.data().toString().contains('trackingId') ? order['trackingId'] : null;

              return Card(
                margin: EdgeInsets.all(12),
                elevation: 3,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order Date: ${order['timestamp'].toDate()}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      SizedBox(height: 8),
                      ...items.map<Widget>((i) => ListTile(
                        title: Text(i['productName']),
                        subtitle: Text("Qty: ${i['quantity']}"),
                        trailing: Text("Rs ${i['productPrice']}"),
                      )),
                      SizedBox(height: 5),
                      Text(
                        "Total: Rs ${order['totalPrice']}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

// ✅ Yeh 2 widgets yahan lagao
                      if (status != null)
                        Text("Status: $status", style: TextStyle(color: Colors.orange)),

                      if (tracking != null)
                        Text("Tracking ID: $tracking", style: TextStyle(color: Colors.grey)),

                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
