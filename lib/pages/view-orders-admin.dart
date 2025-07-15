import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewOrdersAdmin extends StatelessWidget {
  final List<String> statusOptions = ['Pending', 'In Transit', 'Delivered', 'Cancelled'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("View Orders")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final orders = snapshot.data!.docs;

          if (orders.isEmpty) return Center(child: Text("No orders found"));

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var order = orders[index];
              List items = order['item'];
              String currentStatus = order.data().toString().contains('orderStatus')
                  ? order['orderStatus']
                  : 'Pending';

              return Card(
                margin: EdgeInsets.all(10),
                elevation: 3,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Customer: ${order['fullname']}"),
                      Text("Email: ${order['email']}"),
                      Text("Phone: ${order['phone'] ?? 'Not provided'}"),
                      Text("Total: Rs ${order['totalPrice']}",style: TextStyle(color: Colors.green),),
                      Text("Date: ${order['timestamp'].toDate()}"),

                      ...items.map((i) => ListTile(
                        title: Text(i['productName']),
                        subtitle: Text("Qty: ${i['quantity']}"),
                        trailing: Text("Rs ${i['productPrice']}",style: TextStyle(color: Colors.green,fontSize: 16),),
                      )),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Status:", style: TextStyle(fontWeight: FontWeight.bold)),
                          DropdownButton<String>(
                            value: currentStatus,
                            items: statusOptions.map((status) {
                              return DropdownMenuItem(
                                value: status,
                                child: Text(status),
                              );
                            }).toList(),
                            onChanged: (newStatus) async {
                              await FirebaseFirestore.instance
                                  .collection('orders')
                                  .doc(order.id)
                                  .update({'orderStatus': newStatus});
                            },
                          ),
                        ],
                      )
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
