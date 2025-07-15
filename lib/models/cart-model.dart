import 'package:cloud_firestore/cloud_firestore.dart';

class cartItem {
  final String productId;
  final String productName;
  final int productPrice;
  final int quantity;

  const cartItem({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.quantity,
  });

  factory cartItem.fromDocument(DocumentSnapshot doc) {
    return cartItem(
      productId: doc['productId'],
      productName: doc['productName'],
      productPrice: doc['productPrice'],
      quantity: doc['quantity'],
    );
  }

  Map<String, dynamic> tomap(){
    return {
      'productId':productId,
      'productName':productName,
      'productPrice':productPrice,
      'quantity':quantity
    };
  }
}
